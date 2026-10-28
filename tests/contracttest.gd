extends Node
## Контрактный тест: «проигрывает» реальные ответы сервера (записаны cloudflare/test/room.test.mjs
## командой RECORD=файл) через Net._handle и проверяет, что клиент правильно приводит типы
## (числа JSON — float, ключи словарей — строки).
##   godot --headless --path . tests/contracttest.tscn -- --file /путь/к/record.jsonl

var counts := {}
var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _bump(name: String) -> void:
	counts[name] = int(counts.get(name, 0)) + 1


func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var path: String = args[args.find("--file") + 1]
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		print("FAIL: нет файла записи ", path)
		get_tree().quit(2)
		return

	Net.room_joined.connect(func(code: String): _bump("joined"); check(code.length() == 4, "код комнаты"))
	Net.lobby_updated.connect(func(host: int, players: Array):
		_bump("lobby")
		check(host == Net.host_id and host > 0, "host_id int")
		for p in players:
			check(typeof(p.id) == TYPE_INT and typeof(p.score) == TYPE_INT and typeof(p.skin) == TYPE_INT, "типы игрока")
			check(p.skin >= 0 and p.skin < Catalog.INSECT_NAMES.size(), "скин в допустимых пределах")
			check(p.name == Catalog.INSECT_NAMES[p.skin], "имя игрока = название скина (сервер и клиент называют одинаково)")
		var skins := players.map(func(p): return p.skin)
		check(skins.size() == Array(skins).filter(func(v): return skins.count(v) == 1).size(), "скины в комнате не повторяются"))
	Net.phase_changed.connect(func(phase: int, data: Dictionary):
		_bump("phase%d" % phase)
		if phase == Catalog.Phase.PICK:
			check(typeof(data.round) == TYPE_INT and data.offer is Array and data.offer.size() == 4, "PICK: в выборе 4 блока")
			check(data.offer.has("nuke"), "в выборе есть ядерная бомба")
			check(typeof(data.offer[0]) == TYPE_STRING and Catalog.BLOCKS.has(data.offer[0]), "тип блока в предложении")
		if phase == Catalog.Phase.PLACE:
			check(data.chosen.has(Net.my_id), "chosen с int-ключом my_id")
			check(Catalog.BLOCKS.has(data.chosen[Net.my_id]), "chosen значение — тип блока")
		if phase == Catalog.Phase.RUN:
			check(data.order.has(Net.my_id), "order содержит int my_id")
			check(typeof(data.order[0]) == TYPE_INT, "order int"))
	Net.picks_updated.connect(func(picks: Dictionary):
		_bump("picks")
		for k in picks:
			check(typeof(k) == TYPE_INT and typeof(picks[k]) == TYPE_INT, "picks int:int"))
	Net.block_added.connect(func(uid: int, owner_id: int, type: String, origin: Vector2i, rot: int):
		_bump("block")
		check(uid > 0 and owner_id > 0 and Catalog.BLOCKS.has(type), "блок")
		check(rot >= 0 and rot <= 3, "rot в 0..3")
		if rot > 0:
			_bump("block_rot")
		check(Catalog.can_place(type, origin, {}, rot), "позиция блока в сетке с учётом поворота"))
	Net.player_status.connect(func(id: int, status: String): _bump("status"))
	Net.peer_moved.connect(func(id: int, pos: Vector2, vel: Vector2, flip: bool): _bump("state"))
	Net.round_finished.connect(func(result: Dictionary, msg: String, reset: bool):
		_bump("result")
		for k in result:
			check(typeof(k) == TYPE_INT and typeof(result[k].gain) == TYPE_INT, "result int-ключи")
		check(result.has(Net.my_id), "result содержит my_id"))
	Net.game_finished.connect(func(w: int): _bump("over"); check(w == Net.my_id, "победитель — хост"))
	Net.room_error.connect(func(m: String): _bump("error"))

	var lines := 0
	while not f.eof_reached():
		var line := f.get_line().strip_edges()
		if line == "":
			continue
		var parsed = JSON.parse_string(line)
		check(parsed is Dictionary, "строка — JSON-объект")
		Net._handle(parsed)
		lines += 1

	# отказ входа из-за занятого скина: сервер присылает error с taken (числа JSON — float, клиент приводит к int)
	var got_taken: Array = []
	Net.skins_taken.connect(func(t: Array): got_taken.append_array(t))
	Net._handle({"t": "error", "msg": "Скин «Жук» уже занят", "taken": [0.0, 2.0]})
	check(got_taken == [0, 2] and typeof(got_taken[0]) == TYPE_INT, "error.taken → skins_taken с int")

	# сервер: взрыв. Числа JSON — float; клиент приводит зону к Rect2i, а снесённые блоки к int
	var booms: Array = []
	Net.bomb_exploded.connect(func(uid: int, owner_id: int, type: String, zone: Rect2i, destroyed: Array): booms.append([uid, zone, destroyed, type, owner_id]))
	Net._handle({"t": "boom", "uid": 2.0, "owner": 7.0, "type": "bomb", "zone": [9.0, 8.0, 3.0, 5.0], "destroyed": [2.0, 3.0]})
	check(booms.size() == 1 and booms[0][0] == 2 and booms[0][3] == "bomb" and booms[0][4] == 7 and booms[0][1] == Rect2i(9, 8, 3, 5), "boom: uid, тип и зона")
	check(booms[0][2] == [2, 3] and typeof(booms[0][2][0]) == TYPE_INT, "boom: снесённые блоки — int")
	var countdowns: Array = []
	Net.run_countdown.connect(func(s: float): countdowns.append(s))
	Net._handle({"t": "countdown", "time": 20})
	check(countdowns == [20.0], "countdown → run_countdown")
	var suddens: Array = []
	Net.sudden_death.connect(func(ids: Array): suddens.append(ids))
	Net._handle({"t": "sudden", "ids": [1.0, 3.0]})
	check(suddens == [[1, 3]] and typeof(suddens[0][0]) == TYPE_INT, "sudden → sudden_death с int id")
	# pong выравнивает часы: сдвиг считается от замера с наименьшей задержкой
	var t_now := Time.get_unix_time_from_system() * 1000.0
	Net._handle({"t": "pong", "c": t_now - 40.0, "s": t_now + 5000.0})
	check(Net.clock_synced() and absf(Net.clock_offset_ms - 4980.0) < 100.0, "pong → смещение часов (%.0f)" % Net.clock_offset_ms)
	var started: Array = []
	Net.phase_changed.connect(func(phase: int, data: Dictionary): if phase == Catalog.Phase.RUN and data.has("started"): started.append(data.started))
	Net._handle({"t": "phase", "phase": 3, "data": {"order": [1.0], "time": 0, "started": 1700000000123.0}})
	check(started.size() == 1 and typeof(started[0]) == TYPE_FLOAT, "started приходит числом")
	var coins: Array = []
	Net.coin_taken.connect(func(uid: int, pid: int): coins.append([uid, pid]))
	Net._handle({"t": "coin", "uid": 5.0, "id": 2.0})
	check(coins == [[5, 2]] and typeof(coins[0][0]) == TYPE_INT, "coin → coin_taken с int")
	var run_times: Array = []
	Net.phase_changed.connect(func(phase: int, data: Dictionary): if phase == Catalog.Phase.RUN: run_times.append(data.time))
	Net._handle({"t": "phase", "phase": 3, "data": {"order": [1.0], "time": 0}})
	check(run_times.size() == 1 and float(run_times[0]) == 0.0, "у забега time = 0 (без лимита времени)")

	check(Net.my_id > 0 and Net.TARGET_SCORE == 30 and Net.MAX_PLAYERS == 4 and Net.RESULT_TIME > 0.0, "параметры из joined")
	# те же вычисления, что на сервере: Catalog.can_place клиента должен вести себя как canPlace сервера
	var grid_w := Catalog.GRID_W
	check(not Catalog.can_place("plank", Vector2i(grid_w - 2, 5), {}, 0) and Catalog.can_place("plank", Vector2i(grid_w - 1, 5), {}, 1),
		"can_place с поворотом совпадает с canPlace сервера")
	for need in ["joined", "lobby", "phase1", "phase2", "phase3", "picks", "block", "block_rot", "result", "over", "status"]:
		check(counts.has(need), "в записи нет сообщения «%s»" % need)
	print("CONTRACT: строк=%d, счётчики=%s, ошибок=%d" % [lines, counts, failures])
	get_tree().quit(1 if failures > 0 else 0)
