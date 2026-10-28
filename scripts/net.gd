extends Node
## Автозагрузка Net: клиент сетевой игры. Общается с сервером на Cloudflare (Durable Object «Room»)
## простым JSON поверх WebSocket. Вся логика комнат и раундов — на сервере (cloudflare/src/room.js),
## здесь только отправка команд и превращение ответов в сигналы для интерфейса.

signal connection_failed
signal server_lost
signal room_error(msg: String)
signal skins_taken(taken: Array)   # какие скины в комнате уже заняты (ответ /skins или отказ при входе)
signal room_joined(code: String)
signal lobby_updated(host_id: int, players: Array)
signal phase_changed(phase: int, data: Dictionary)
signal picks_updated(picks: Dictionary)
signal block_added(uid: int, owner_id: int, type: String, origin: Vector2i, rot: int)
signal place_rejected(msg: String)
signal bomb_exploded(uid: int, owner_id: int, type: String, zone: Rect2i, destroyed: Array)   # сервер: бомба игрока owner_id взорвалась при установке, зона в клетках и снесённые блоки
signal turn_changed(player_id: int, seconds: float)   # классический режим: чей сейчас ход расстановки
signal peer_moved(id: int, pos: Vector2, vel: Vector2, flip: bool)
signal player_status(id: int, status: String)
signal sudden_death(ids: Array)   # сервер: ничья на финише, решающий раунд между этими игроками
signal coin_taken(uid: int, player_id: int)   # сервер: игрок подобрал монету (её прячут у всех)
signal run_countdown(seconds: float)   # сервер: первый игрок дошёл, остальным осталось столько секунд
signal round_finished(result: Dictionary, msg: String, reset_blocks: bool)
signal game_finished(winner_id: int)

const PING_INTERVAL := 20.0

# Значения по умолчанию; сервер присылает настоящие в сообщении «joined».
var TARGET_SCORE := 30
# Правила комнаты (меняет хозяин в лобби): ключи и допустимые значения те же, что в RULES на сервере.
var rules := {"map": 0, "mode": "party", "death": "out", "gravity": "normal", "sprint": true, "target": 30, "accumulate": true, "offer": 4}
var MAX_PLAYERS := 4
var RESULT_TIME := 6.0

var room_code := ""
var my_id := 0
var host_id := 0
var players: Array = []   # [{id, name, score, skin}]

var clock_offset_ms := 0.0   # разница часов сервера и клиента (сервер − клиент), мс
var _best_rtt := INF
var _ws: WebSocketPeer
var _opened := false
var _joined := false
var _got_error := false
var _ping_left := PING_INTERVAL
var _peek: HTTPRequest
var _peek_code := ""


func _ready() -> void:
	Catalog.setup_input()
	set_process(false)
	_peek = HTTPRequest.new()
	_peek.timeout = 6.0
	_peek.request_completed.connect(_on_peek_done)
	add_child(_peek)


# ======================================================================
#  Подключение
# ======================================================================

func create_room(base_url: String, skin: int) -> bool:
	return _open("%s/ws?mode=create&skin=%d" % [_normalize(base_url), skin])


func join_room(base_url: String, code: String, skin: int) -> bool:
	return _open("%s/ws?mode=join&code=%s&skin=%d" % [_normalize(base_url), code.uri_encode(), skin])


## Спрашивает у сервера, какие скины в комнате заняты; ответ придёт сигналом skins_taken.
func peek_room(base_url: String, code: String) -> void:
	var http_url := _normalize(base_url).replace("wss://", "https://").replace("ws://", "http://")
	_peek_code = code
	_peek.cancel_request()
	_peek.request("%s/skins?code=%s" % [http_url, code.uri_encode()])


func _on_peek_done(result: int, status: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or status != 200:
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if parsed is Dictionary and parsed.get("taken") is Array:
		skins_taken.emit(_ints(parsed.taken))


func leave() -> void:
	if _ws != null:
		_ws.close(1000, "leave")
	_reset()


func is_connected_to_server() -> bool:
	return _ws != null and _ws.get_ready_state() == WebSocketPeer.STATE_OPEN


## Приводит адрес к виду ws(s)://хост[:порт] без завершающего «/».
func _normalize(url: String) -> String:
	var u := url.strip_edges()
	while u.ends_with("/"):
		u = u.left(u.length() - 1)
	if u.begins_with("https://"):
		u = "wss://" + u.substr(8)
	elif u.begins_with("http://"):
		u = "ws://" + u.substr(7)
	elif not (u.begins_with("ws://") or u.begins_with("wss://")):
		u = "wss://" + u
	return u


func _open(url: String) -> bool:
	leave()
	_ws = WebSocketPeer.new()
	if _ws.connect_to_url(url) != OK:
		_ws = null
		return false
	_opened = false
	_joined = false
	_got_error = false
	_best_rtt = INF
	clock_offset_ms = 0.0
	_ping_left = PING_INTERVAL
	set_process(true)
	return true


func _reset() -> void:
	_ws = null
	_opened = false
	_joined = false
	_got_error = false
	room_code = ""
	my_id = 0
	host_id = 0
	players = []
	set_process(false)


func _process(delta: float) -> void:
	if _ws == null:
		return
	_ws.poll()
	match _ws.get_ready_state():
		WebSocketPeer.STATE_OPEN:
			_opened = true
			while _ws.get_available_packet_count() > 0:
				var parsed = JSON.parse_string(_ws.get_packet().get_string_from_utf8())
				if parsed is Dictionary:
					_handle(parsed)
				if _ws == null:
					return
			_ping_left -= delta
			if _ping_left <= 0.0:
				_ping_left = PING_INTERVAL
				_send_ping()
		WebSocketPeer.STATE_CLOSED:
			var was_joined := _joined
			var had_error := _got_error
			_reset()
			if was_joined:
				server_lost.emit()
			elif not had_error:
				connection_failed.emit()


func _send(msg: Dictionary) -> void:
	if is_connected_to_server():
		_ws.send_text(JSON.stringify(msg))


# ======================================================================
#  Команды серверу
# ======================================================================

func start_game() -> void:
	_send({"t": "start"})


func back_to_lobby() -> void:
	_send({"t": "back"})


func pick(idx: int) -> void:
	_send({"t": "pick", "idx": idx})


func place(x: int, y: int, rot: int) -> void:
	_send({"t": "place", "x": x, "y": y, "rot": rot})


func send_state(px: float, py: float, vx: float, vy: float, flip: bool) -> void:
	_send({"t": "state", "x": px, "y": py, "vx": vx, "vy": vy, "flip": flip})


func send_finished() -> void:
	_send({"t": "finished"})


func _send_ping() -> void:
	_send({"t": "ping", "c": Time.get_unix_time_from_system() * 1000.0})


## Время сервера в мс (по выровненным часам).
func clock_synced() -> bool:
	return _best_rtt < INF


func server_now_ms() -> float:
	return Time.get_unix_time_from_system() * 1000.0 + clock_offset_ms


func send_coin(block_uid: int) -> void:
	_send({"t": "coin", "uid": block_uid})


func send_giveup() -> void:
	_send({"t": "giveup"})


func send_died(block_uid: int) -> void:
	_send({"t": "died", "uid": block_uid})


# ======================================================================
#  Ответы сервера
# ======================================================================

func _handle(m: Dictionary) -> void:
	match str(m.get("t", "")):
		"error":
			_got_error = true
			if m.get("taken") is Array:
				skins_taken.emit(_ints(m.taken))
			room_error.emit(str(m.get("msg", "Ошибка")))
		"joined":
			_joined = true
			room_code = str(m.code)
			my_id = int(m.id)
			host_id = int(m.host)
			TARGET_SCORE = int(m.target)
			_set_rules(m.get("rules", {}))
			MAX_PLAYERS = int(m.max)
			RESULT_TIME = float(m.resultTime)
			_send_ping()
			room_joined.emit(room_code)
		"lobby":
			host_id = int(m.host)
			players = _fix_players(m.players)
			_set_rules(m.get("rules", {}))
			lobby_updated.emit(host_id, players)
		"phase":
			phase_changed.emit(int(m.phase), _fix_phase(m.data))
		"picks":
			picks_updated.emit(_int_keys(m.picks, true))
		"block":
			block_added.emit(int(m.uid), int(m.owner), str(m.type), Vector2i(int(m.x), int(m.y)), int(m.get("rot", 0)))
		"place_rejected":
			place_rejected.emit(str(m.msg))
		"boom":
			var z: Array = m.zone
			bomb_exploded.emit(int(m.uid), int(m.get("owner", 0)), str(m.type), Rect2i(int(z[0]), int(z[1]), int(z[2]), int(z[3])), _ints(m.destroyed))
		"state":
			peer_moved.emit(int(m.id), Vector2(float(m.x), float(m.y)),
				Vector2(float(m.vx), float(m.vy)), bool(m.flip))
		"status":
			player_status.emit(int(m.id), str(m.status))
		"pong":
			# часы сервера = наши + offset; берём замер с наименьшей задержкой — он точнее всего
			var now := Time.get_unix_time_from_system() * 1000.0
			var rtt := now - float(m.c)
			if rtt < _best_rtt:
				_best_rtt = rtt
				clock_offset_ms = float(m.s) + rtt / 2.0 - now
		"sudden":
			sudden_death.emit(_ints(m.ids))
		"turn":
			turn_changed.emit(int(m.id), float(m.time))
		"coin":
			coin_taken.emit(int(m.uid), int(m.id))
		"countdown":
			run_countdown.emit(float(m.time))
		"result":
			var result := {}
			for key in m.result:
				var r: Dictionary = m.result[key]
				result[int(key)] = {"gain": int(r.gain), "notes": r.notes}
			round_finished.emit(result, str(m.msg), bool(m.reset))
		"over":
			game_finished.emit(int(m.winner))


# JSON отдаёт числа как float, а ключи словарей как строки — приводим к ожидаемым типам.

## Правила с сервера; числа из JSON — float, приводим к int.
func _set_rules(r: Dictionary) -> void:
	for k in r:
		var v = r[k]
		rules[k] = int(v) if v is float else v
	TARGET_SCORE = int(rules.target)


func set_rule(key: String, value) -> void:
	_send({"t": "rule", "key": key, "value": value})


func _fix_players(arr: Array) -> Array:
	var out := []
	for p in arr:
		out.append({"id": int(p.id), "name": str(p.name), "score": int(p.score), "skin": int(p.skin)})
	return out


func _ints(arr: Array) -> Array:
	var out := []
	for v in arr:
		out.append(int(v))
	return out


func _int_keys(d: Dictionary, int_values: bool = false) -> Dictionary:
	var out := {}
	for key in d:
		out[int(key)] = int(d[key]) if int_values else d[key]
	return out


func _fix_phase(d: Dictionary) -> Dictionary:
	var out := d.duplicate()
	if out.has("round"):
		out["round"] = int(out["round"])
	if out.has("chosen"):
		out["chosen"] = _int_keys(out["chosen"])
	if out.has("started"):
		out["started"] = float(out["started"])   # время сервера в начале забега, мс
	if out.has("order"):
		var order := []
		for id in out["order"]:
			order.append(int(id))
		out["order"] = order
	return out
