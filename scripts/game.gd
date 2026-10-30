extends Node2D
## Клиентская часть матча: уровень, блоки, игроки, интерфейс.
## Правила раундов и очки считает сервер (net.gd), здесь только отображение и ввод.

signal leave_requested

const CELL := Catalog.CELL
const RUN_ZOOM := 2.3                # во время забега камера держится у игрока; на расстановке видна вся карта
const VIEW_CENTER := Vector2(640, 360)

var phase: int = -1
var round_no := 0
var host_id := 0
var players_info: Dictionary = {}    # id -> {name, score, skin}
var offer: Array = []
var picks: Dictionary = {}           # индекс предложения -> id игрока
var chosen: Dictionary = {}          # id -> тип блока
var my_type := ""
var placed := false
var turn_id := 0                      # классический режим: чей ход расстановки (0 — все ставят сразу)
var ghost_origin := Vector2i(16, 8)
var ghost_rot := 0                   # поворот призрака: четверти оборота по часовой стрелке
var occupied: Dictionary = {}
var block_nodes: Dictionary = {}     # uid -> Node
var roofs_root: Node2D                # земля текущей карты
var sky_root: Node2D                  # фон текущей карты
var goal_area: Area2D                 # флаг текущей карты
var level_map := 0                    # индекс построенной карты
var coin_nodes: Dictionary = {}      # uid -> Area2D монеты (прячутся, когда подобраны)
var my_coins := 0                    # сколько монет подобрано в этом забеге
var block_defs: Dictionary = {}      # uid -> {owner, type, origin, rot}: что сейчас стоит на уровне (после взрывов — без снесённого)
var my_state := "idle"               # idle / alive / dead / finished
var run_clock := 0.0
var send_timer := 0.0
var deadline := 0.0
var my_id := 0

var blocks_root: Node2D
var remotes_root: Node2D
var player: Player
var ghost: ColorRect
var ghost_vis: Node2D                # картинка блока на призраке (повёрнутая)
var remote_nodes: Dictionary = {}
var remote_target: Dictionary = {}

var ui: CanvasLayer
var top_label: Label
var score_label: Label
var info_label: Label
var center_label: Label
var pick_box: HFlowContainer
var pick_buttons: Array = []
var place_btn: Button
var rot_ccw_btn: Button
var rot_cw_btn: Button
var lobby_btn: Button
var giveup_btn: Button
var my_ghost := false                 # погибший по правилам «призрак»/«труп» продолжает двигаться, но уже ни на что не влияет
var sudden_ids: Array = []            # ничья на финише: между кем решающий раунд (пусто — обычная игра)
var giveup_armed := 0.0               # до какого момента (сек) второе нажатие «Сдаться» подтверждает
var finish_deadline := 0.0            # когда кончится время после первого финиша; 0 — таймера нет
var touch_root: Node2D
var cam: Camera2D
var grid: GridOverlay
var sprint_btn: TouchScreenButton
var ported: Array = []              # логика блоков из scripts/ported (лёд, мёд, яд, пила на рельсе, топор, ветер)


func _ready() -> void:
	my_id = Net.my_id
	occupied = Catalog.static_occupied(level_map)
	_build_level()
	_build_ui()
	_build_touch()
	Net.lobby_updated.connect(_on_lobby)
	Net.picks_updated.connect(_on_picks)
	Net.block_added.connect(_on_block_added)
	Net.place_rejected.connect(_on_place_rejected)
	Net.bomb_exploded.connect(_on_boom)
	Net.peer_moved.connect(_on_peer_moved)
	Net.player_status.connect(_on_player_status)
	Net.run_countdown.connect(_on_run_countdown)
	Net.coin_taken.connect(_on_coin_taken)
	Net.turn_changed.connect(_on_turn_changed)
	Net.sudden_death.connect(func(ids: Array): sudden_ids = ids)
	Net.round_finished.connect(_on_round_finished)
	Net.game_finished.connect(_on_game_finished)
	_on_lobby(Net.host_id, Net.players)


# ======================================================================
#  Построение мира
# ======================================================================

func _build_level() -> void:
	sky_root = Node2D.new()
	add_child(sky_root)

	blocks_root = Node2D.new()
	add_child(blocks_root)
	roofs_root = Node2D.new()
	add_child(roofs_root)
	_set_map(int(Net.rules.map))

	remotes_root = Node2D.new()
	add_child(remotes_root)

	player = Player.new()
	player.body_color = _color_of(my_id)
	player.kind = _kind_of(my_id)
	player.visible = false
	add_child(player)
	player.died.connect(_on_player_died)
	player.succeeded.connect(_on_player_succeeded)

	grid = GridOverlay.new()
	add_child(grid)

	cam = Camera2D.new()
	cam.limit_left = 0
	cam.limit_top = 0
	cam.limit_right = Catalog.GRID_W * CELL
	cam.limit_bottom = 720
	cam.position = VIEW_CENTER
	add_child(cam)
	cam.make_current()

	ghost = ColorRect.new()
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.visible = false
	ghost.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ghost.z_index = 5
	add_child(ghost)


## Уровень выбранной карты (его выбирает хозяин в лобби): векторный рисунок уровня (assets/levels/levelN.vec) лежит фоном, земля и платформы — невидимые
## коллайдеры ровно по нарисованному, опасные зоны (шипы, слизь) убивают при касании. Старый уровень убираем.
func _set_map(map: int) -> void:
	for root_node in [roofs_root, sky_root]:
		for c in root_node.get_children():
			root_node.remove_child(c)
			c.queue_free()
	sky_root.add_child(VectorLevel.make_node("res://assets/levels/level%d.vec" % (map + 1)))   # векторный фон: чёткий при любом зуме
	for r in Catalog.MAPS[map].rects:
		var body := StaticBody2D.new()
		_fill_body(body, r, Color.WHITE, "ground")
		roofs_root.add_child(body)
	for r in Catalog.MAPS[map].hazards:
		var zone := Area2D.new()
		zone.collision_layer = 0
		zone.collision_mask = 2
		var size := Vector2(r.size) * CELL
		zone.position = Vector2(r.position) * CELL + size / 2.0
		var shape := CollisionShape2D.new()
		var rs := RectangleShape2D.new()
		rs.size = size
		shape.shape = rs
		zone.add_child(shape)
		zone.body_entered.connect(_on_hazard_zone)
		roofs_root.add_child(zone)
	level_map = map
	_build_goal()
	occupied = Catalog.static_occupied(map)


## Шипы и слизь на карте убивают, как любая опасность (блока за ними нет, поэтому очков хозяину не будет).
func _on_hazard_zone(body: Node) -> void:
	if body == player:
		_die(-1)


func _fill_body(body: PhysicsBody2D, rect: Rect2i, color: Color, art := "", art_seed := 0, rot := 0) -> void:
	var size := Vector2(rect.size) * CELL
	body.position = Vector2(rect.position) * CELL + size / 2.0
	var shape := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = size
	shape.shape = rs
	body.add_child(shape)
	if art == "ground":
		pass    # земля уровня нарисована на фоне, тут только коллайдер
	elif art != "":
		body.add_child(_rotated(_make_visual(art, color), rot))
	else:
		var vis := ColorRect.new()
		vis.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vis.color = color
		vis.size = size
		vis.position = -size / 2.0
		body.add_child(vis)


func _build_goal() -> void:
	if is_instance_valid(goal_area):
		goal_area.queue_free()
	var cell := Catalog.goal_cell(level_map)
	var area := Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 2
	area.position = Vector2(cell.x * CELL + CELL, (cell.y + 1) * CELL - CELL * 2)
	var shape := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(CELL * 2, CELL * 4)
	shape.shape = rs
	area.add_child(shape)
	area.body_entered.connect(_on_goal_entered)
	add_child(area)
	goal_area = area


## Картинка блока без поворота (центр в начале координат, размер — как у блока в исходном положении).
## style: "block" — блок на уровне, "ghost" — призрак при расстановке (показывает дальность), "icon" — значок в выборе блока.
func _make_visual(type: String, color: Color, style := "block") -> Node2D:
	var px := Vector2(Catalog.size_of(type)) * CELL
	var kind: String = Catalog.BLOCKS[type].kind
	if kind == "solid" or kind == "mover":
		return Art.make_block(type, px, color)
	if kind == "bomb":
		return Art.make_bomb(type, px, color)
	if kind == "coin":
		return Art.make_coin(px, color)

	if kind == "shooter" or kind == "flame" or kind == "pendulum":
		var info: Dictionary = Catalog.BLOCKS[type]
		var arm: float = float(info.get("arm", 0.0)) * CELL if style != "icon" else 0.0
		var reach: float = float(info.get("range", 0)) * CELL if style == "ghost" else 0.0
		return Art.make_trap(type, px, color, arm, reach)
	if Catalog.PORTED_ART.has(kind):
		return Art.make_ported(type, px, color)
	return Art.make_hazard(type, px, color)    # шипы, шестерёнка и пружина


## Оборачивает картинку в узел, повёрнутый на rot четвертей оборота по часовой стрелке.
func _rotated(vis: Node2D, rot: int) -> Node2D:
	var wrap := Node2D.new()
	wrap.rotation = rot * PI / 2.0
	wrap.add_child(vis)
	return wrap


func _spawn_block(uid: int, owner_id: int, type: String, origin: Vector2i, rot := 0) -> void:
	var info: Dictionary = Catalog.BLOCKS[type]
	var size := Catalog.size_of(type, rot)
	var color: Color = info.color
	var kind: String = info.kind
	var rect := Rect2i(origin, size)
	var node: Node2D
	if kind == "solid":
		var body := StaticBody2D.new()
		_fill_body(body, rect, color, type, 0, rot)
		node = body
	elif Catalog.PORTED_KINDS.has(kind):
		node = _spawn_ported(uid, type, kind, rect, rot, color)
	else:
		var area := Area2D.new()
		area.collision_layer = 0
		area.collision_mask = 2
		var px := Vector2(size) * CELL
		area.position = Vector2(origin) * CELL + px / 2.0
		var shape := CollisionShape2D.new()
		var rs := RectangleShape2D.new()
		rs.size = px
		shape.shape = rs
		area.add_child(shape)
		var vis := _make_visual(type, color)
		area.add_child(_rotated(vis, rot))
		area.body_entered.connect(_on_block_touched.bind(uid, kind, rot))
		node = area
	node.set_meta("owner", owner_id)
	node.set_meta("rect", Rect2(Vector2(origin) * CELL, Vector2(size) * CELL))
	block_defs[uid] = {"owner": owner_id, "type": type, "origin": origin, "rot": rot}
	var tag := ColorRect.new()   # маленькая метка цвета владельца блока
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.color = _color_of(owner_id)
	tag.size = Vector2(6, 6)
	tag.position = -Vector2(size) * CELL / 2.0 + Vector2(2, 2)
	node.add_child(tag)
	blocks_root.add_child(node)
	block_nodes[uid] = node
	Catalog.mark(type, origin, occupied, rot)


## Блок, логику которого ведёт класс из scripts/ported. Возвращает корневой узел блока.
func _spawn_ported(uid: int, type: String, kind: String, rect: Rect2i, rot: int, color: Color) -> Node2D:
	var size := Vector2(rect.size) * CELL
	var center := Vector2(rect.position) * CELL + size / 2.0
	var info: Dictionary = Catalog.BLOCKS[type]
	var dir := Catalog.facing_of(rot)
	var logic: Node
	var node: Node2D
	match kind:
		"ice", "honey":    # твёрдая платформа с особой поверхностью: зона над верхней гранью меняет трение, бег и прыжок
			var body := StaticBody2D.new()
			_fill_body(body, rect, color, type, 0, rot)
			logic = Ice.new() if kind == "ice" else Honey.new()
			body.add_child(logic)
			logic.setup_zone(Vector2(size.x, 6), Vector2(0, -size.y / 2.0 - 3.0))
			node = body
		"treadmill":        # платформа-конвейер: несёт того, кто стоит или прижат к ней
			var body := StaticBody2D.new()
			_fill_body(body, rect, color, type, 0, rot)
			var belt := Treadmill.new()
			belt.belt_dir = Vector2.RIGHT.rotated(rot * PI / 2.0)
			body.add_child(belt)
			belt.setup_zone(size + Vector2(10, 10))
			logic = belt
			node = body
		"mover":            # листок: ездит влево-вправо, повёрнутый — вверх-вниз; физика сама возит игрока
			var body := AnimatableBody2D.new()
			body.sync_to_physics = true
			_fill_body(body, rect, color, type, 0, rot)
			var plat: ActiveBlock = HorizontalMovingPlatform.new() if rot % 2 == 0 else MovingPlatform.new()
			plat.move_speed = 50.0
			plat.max_distance = CELL * 6.0
			plat.initial_moved = CELL * 3.0
			plat.move_target = body
			if rot % 2 == 1:
				plat.move_angle = 90.0
			body.add_child(plat)
			logic = plat
			node = body
		"toxic":
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var toxic := ToxicWaste.new()
			node.add_child(toxic)
			toxic.setup_zone(size)
			logic = toxic
		"spring":
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var spring := Spring.new()
			spring.direction = dir
			node.add_child(spring)
			spring.setup_zone(size)
			logic = spring
		"coin":
			node = Node2D.new()
			node.position = center
			var coin := Coin.new()
			coin.return_on_death = false
			coin.add_child(_make_visual(type, color))
			coin.coin_picked.connect(_on_coin_picked.bind(uid))
			node.add_child(coin)
			coin_nodes[uid] = node
			logic = coin
		"goal":             # блок «Флаг»: дотронулся — финиш
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var goal := GoalBlock.new()
			node.add_child(goal)
			goal.setup_zone(size)
			logic = goal
		"sawspin":          # шестерёнка: вращается и убивает
			node = Node2D.new()
			node.position = center
			var saw := SawSpin.new()
			saw.spin_speed = 6.0
			saw.kill_radius = minf(size.x, size.y) / 2.0 - 2.0
			saw.add_child(_make_visual(type, color))
			node.add_child(saw)
			logic = saw
		"sawslide":         # пила-бегунок: крутится и ездит туда-обратно вдоль блока
			node = Node2D.new()
			node.position = center
			node.rotation = (rot % 2) * PI / 2.0
			var length := maxf(size.x, size.y)
			var rail: Art.PortedDraw = Art.make_ported("sawrail", Vector2(length, CELL), color)
			rail.show_blade = false
			node.add_child(rail)
			var slider := SawSpinAndMove.new()
			slider.move_speed = 40.0
			slider.max_left = (length - CELL) / 2.0
			slider.max_right = (length - CELL) / 2.0
			slider.kill_radius = CELL / 2.0 - 1.0
			slider.add_child(Art.make_ported("sawblade", Vector2(CELL, CELL), color))
			node.add_child(slider)
			logic = slider
		"sawrail":
			node = Node2D.new()
			node.position = center
			var rail: Art.PortedDraw = _make_visual(type, color)
			rail.show_blade = false
			node.add_child(_rotated(rail, rot))
			var saw := LinearSaw.new()
			var sdir := Vector2.RIGHT if rot % 2 == 0 else Vector2.DOWN
			var length := maxf(size.x, size.y)
			saw.travel_dir = sdir
			saw.travel_distance = length - CELL
			saw.blade_size = Vector2(CELL - 4, CELL - 4)
			saw.position = -sdir * (length - CELL) / 2.0
			saw.add_child(Art.make_ported("sawblade", Vector2(CELL, CELL), color))
			node.add_child(saw)
			logic = saw
		"pendulum":         # маятник = топор: качается по общим часам забега
			node = Node2D.new()
			node.position = center
			node.rotation = dir.angle() - PI / 2.0
			var pivot := Node2D.new()
			var arm_px: float = float(info.arm) * CELL
			pivot.add_child(Art.make_ported("axearm", Vector2(CELL, arm_px), color))
			node.add_child(pivot)
			node.add_child(Art.make_trap(type, size, color, 0.0, 0.0))
			var axe := SwingingAxe.new()
			axe.rotate_locked = pivot
			axe.axe_length = arm_px
			axe.axe_head_size = Vector2(13, 13)
			axe.amplitude = deg_to_rad(float(info.swing))
			axe.saw_move_speed = float(info.freq)
			axe.swing_phase = float(uid) * 0.7
			node.add_child(axe)
			logic = axe
		"shooter":          # арбалет
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var launcher := ProjectileLauncher.new()
			launcher.shoot_dir = dir
			launcher.first_shot_delay = float(info.first)
			launcher.interval = float(info.period)
			launcher.muzzle_offset = (size.y / 2.0 if dir.x == 0.0 else size.x / 2.0) + 4.0
			node.add_child(launcher)
			logic = launcher
		"flame":            # огнемёт
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var lighter := Lighter.new()
			var half: float = size.y / 2.0 if dir.x == 0.0 else size.x / 2.0
			var reach: float = float(info.range) * CELL
			var flame := Art.make_flame(reach)
			flame.position = dir * half
			flame.rotation = dir.angle() + PI / 2.0
			flame.visible = false
			lighter.add_child(flame)
			lighter.flame_node = flame
			lighter.on_time = float(info.on)
			lighter.interval = float(info.period)
			lighter.phase = float(uid) * 0.7
			node.add_child(lighter)
			var zone_size := Vector2(CELL + 8.0, reach) if dir.x == 0.0 else Vector2(reach, CELL + 8.0)
			lighter.setup_zone(zone_size, dir * (half + reach / 2.0))
			logic = lighter
		"teleporter":
			node = Node2D.new()
			node.position = center
			node.add_child(_make_visual(type, color))
			var tp := Teleporter.new()
			node.add_child(tp)
			logic = tp
		"upblower":         # вентилятор: поток в сторону поворота
			node = Node2D.new()
			node.position = center
			node.add_child(_rotated(_make_visual(type, color), rot))
			var blower := UpBlower.new()
			blower.blow_dir = dir
			node.add_child(blower)
			var zs := Vector2(CELL * 2.0, CELL * 5.0) if dir.x == 0.0 else Vector2(CELL * 5.0, CELL * 2.0)
			blower.setup_zone(zs, dir * (CELL / 2.0 + CELL * 2.5))
			logic = blower
		"boulder":          # валун: срывается, когда игрок оказывается впереди, и катится
			node = Node2D.new()
			node.position = center
			var rock := Boulder.new()
			rock.roll_dir = Vector2.RIGHT.rotated(rot * PI / 2.0)
			rock.add_child(_make_visual(type, color))
			node.add_child(rock)
			rock.setup_zone(size - Vector2(4, 4))
			logic = rock
		"blackhole":
			node = Node2D.new()
			node.position = center
			var hole := Blackhole.new()
			hole.add_child(_make_visual(type, color))
			node.add_child(hole)
			hole.pull_radius = CELL * 3.5
			hole.setup_zone(Vector2.ONE * hole.pull_radius * 2.0)
			logic = hole
		"wind":
			node = Node2D.new()
			node.position = center
			node.add_child(_make_visual(type, color))
			var wind := WindArea.new()
			wind.area_size = size
			wind.blow_direction = dir
			wind.pause_wind = phase != Catalog.Phase.RUN
			node.add_child(wind)
			wind.set_meta("uid", uid)
			ported.append(wind)
			return node
	logic.set_meta("uid", uid)
	if logic is Placeable:
		logic.original_position = logic.position
	ported.append(logic)
	return node


## Включает или выключает блоки из ported: в забеге пилы, топоры и яд работают, ветер дует; в остальное время стоят.
func _set_ported_active(on: bool) -> void:
	ported = ported.filter(func(p): return is_instance_valid(p))
	if on:
		Teleporter.pair_all()
	for p in ported:
		if p is SawSpin or p is SawSpinAndMove:
			p.reset_play_state()
			p.spin_active = on
		elif p is WindArea:
			p.pause_wind = not on
			if not on:
				for c: Character in p.affected_characters:
					c.wind_x = 0.0
					c.wind_y = 0.0
		else:
			p.reset_play_state()
			p.sync_clock = -1.0
			if p is ActiveBlock:
				p.is_active = on
				p.paused = false


func _on_player_died(_cause: String) -> void:
	var uid := -1
	if is_instance_valid(player.last_killer) and player.last_killer.has_meta("uid"):
		uid = int(player.last_killer.get_meta("uid"))
	_die(uid)


# ======================================================================
#  Бомбы. Взрываются сразу при установке в фазе расстановки: сервер присылает «boom» с зоной и списком
#  снесённых блоков, самой бомбы на уровне не остаётся. Бомбой убирают чужие постройки и ловушки.
# ======================================================================

## Сервер: бомба type взорвалась, в зоне zone (клетки) снесены блоки destroyed.
func _on_boom(_uid: int, owner_id: int, type: String, zone: Rect2i, destroyed: Array) -> void:
	if owner_id == my_id:
		_mark_placed("Бомба взорвалась. Ждём остальных…")
	var zone_px := Rect2(Vector2(zone.position) * CELL, Vector2(zone.size) * CELL)
	var nuke := type == "nuke"
	var fx := Art.make_blast(zone_px.size, 1.1 if nuke else 0.5)
	fx.position = zone_px.get_center()
	add_child(fx)
	if nuke:
		_flash()
	for d in destroyed:
		_destroy_block(d)
	_rebuild_occupied()


func _destroy_block(uid: int) -> void:
	var node = block_nodes.get(uid)
	block_nodes.erase(uid)
	coin_nodes.erase(uid)
	block_defs.erase(uid)
	if is_instance_valid(node):
		node.queue_free()    # вместе с блоком исчезают его стрелы и пламя


## После взрыва клетки снесённых построек снова свободны (так же считает сервер).
func _rebuild_occupied() -> void:
	occupied = Catalog.static_occupied(level_map)
	for d in block_defs.values():
		Catalog.mark(d.type, d.origin, occupied, d.rot)


## Ядерная вспышка на весь экран.
func _flash() -> void:
	var f := ColorRect.new()
	f.mouse_filter = Control.MOUSE_FILTER_IGNORE
	f.color = Color(1, 1, 0.9, 0.9)
	f.size = Vector2(1280, 720)
	ui.add_child(f)
	var tw := create_tween()
	tw.tween_property(f, "color:a", 0.0, 1.2)
	tw.tween_callback(f.queue_free)


func _clear_blocks() -> void:
	for p in ported:
		if is_instance_valid(p) and p is Placeable:
			p.disable_0()      # узел удалится только в конце кадра — до этого он не должен ни убивать, ни дуть
		elif is_instance_valid(p) and p is WindArea:
			p.pause_wind = true
		elif is_instance_valid(p) and (p is SawSpin or p is SawSpinAndMove):
			p.spin_active = false
	for uid in block_nodes:
		if is_instance_valid(block_nodes[uid]):
			block_nodes[uid].queue_free()
	block_nodes.clear()
	coin_nodes.clear()
	ported.clear()
	block_defs.clear()
	occupied = Catalog.static_occupied(level_map)


# ======================================================================
#  Интерфейс
# ======================================================================

func _label(pos: Vector2, size: Vector2, font_size: int,
		align: HorizontalAlignment = HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var l := Label.new()
	l.position = pos
	l.size = size
	l.horizontal_alignment = align
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("outline_size", 6)
	ui.add_child(l)
	return l


func _build_ui() -> void:
	ui = CanvasLayer.new()
	add_child(ui)
	top_label = _label(Vector2(20, 8), Vector2(760, 44), 30)
	score_label = _label(Vector2(840, 8), Vector2(420, 120), 24, HORIZONTAL_ALIGNMENT_RIGHT)
	info_label = _label(Vector2(160, 500), Vector2(960, 90), 28, HORIZONTAL_ALIGNMENT_CENTER)
	center_label = _label(Vector2(240, 170), Vector2(800, 260), 34, HORIZONTAL_ALIGNMENT_CENTER)

	pick_box = HFlowContainer.new()    # 5–7 блоков не помещаются в одну строку — переносятся
	pick_box.position = Vector2(20, 150)
	pick_box.size = Vector2(1240, 310)
	pick_box.alignment = FlowContainer.ALIGNMENT_CENTER
	pick_box.add_theme_constant_override("h_separation", 14)
	pick_box.add_theme_constant_override("v_separation", 14)
	ui.add_child(pick_box)

	place_btn = Button.new()
	place_btn.text = "Поставить"
	place_btn.position = Vector2(520, 600)
	place_btn.size = Vector2(240, 90)
	place_btn.add_theme_font_size_override("font_size", 30)
	place_btn.pressed.connect(func(): Net.place(ghost_origin.x, ghost_origin.y, ghost_rot))
	ui.add_child(place_btn)

	rot_ccw_btn = _rot_button(false, Vector2(380, 600))
	rot_cw_btn = _rot_button(true, Vector2(780, 600))

	lobby_btn = Button.new()
	lobby_btn.text = "В лобби"
	lobby_btn.position = Vector2(520, 460)
	lobby_btn.size = Vector2(240, 90)
	lobby_btn.add_theme_font_size_override("font_size", 30)
	lobby_btn.pressed.connect(func(): Net.back_to_lobby())
	ui.add_child(lobby_btn)

	var leave := Button.new()
	leave.text = "Выйти"
	leave.position = Vector2(20, 56)
	leave.size = Vector2(130, 44)
	leave.add_theme_font_size_override("font_size", 22)
	leave.pressed.connect(func(): leave_requested.emit())
	ui.add_child(leave)

	giveup_btn = Button.new()
	giveup_btn.text = "Сдаться"
	giveup_btn.position = Vector2(20, 108)
	giveup_btn.size = Vector2(150, 44)
	giveup_btn.add_theme_font_size_override("font_size", 22)
	giveup_btn.pressed.connect(_on_giveup_pressed)
	ui.add_child(giveup_btn)

	_hide_panels()


## «Сдаться» с подтверждением: первое нажатие спрашивает «Точно?», второе в течение 3 секунд сдаётся (чтобы не нажать случайно).
func _on_giveup_pressed() -> void:
	if phase != Catalog.Phase.RUN or my_state != "alive":
		return
	var now := Time.get_ticks_msec() / 1000.0
	if now > giveup_armed:
		giveup_armed = now + 3.0
		giveup_btn.text = "Точно?"
		return
	_leave_run("Вы сдались. Ждём остальных…", false)
	Net.send_giveup()


## Игрок выбыл из забега, не дойдя до финиша. По правилам комнаты погибший может остаться призраком или трупом
## (двигается и видим другим, но не гибнет, не подбирает монеты и не финиширует); сдавшийся и при «выбывает» исчезает.
func _leave_run(text: String, died := true) -> void:
	my_state = "dead"
	giveup_btn.hide()
	var mode: String = Net.rules.death
	if died and mode != "out":
		my_ghost = true
		player.modulate = Color(1, 1, 1, 0.45) if mode == "ghost" else Color(0.55, 0.55, 0.55, 0.85)
		player.jump_scale = 0.6 if mode == "corpse" else 1.0
		player.sprint_allowed = mode == "ghost" and bool(Net.rules.sprint)
		player.is_ghost = true      # блоки из ported на призрака не действуют
		player.dying = false
		player.dead = false
		player.reset_variables()
		info_label.text = text + (" Вы призрак." if mode == "ghost" else " Вы труп: можно прыгать на клетку.")
		return
	player.active = false
	player.visible = false
	_set_touch(false)
	info_label.text = text


## Кнопка поворота блока; стрелку рисуем сами, чтобы не зависеть от наличия символов ↺ ↻ в шрифте.
func _rot_button(clockwise: bool, pos: Vector2) -> Button:
	var b := Button.new()
	b.position = pos
	b.size = Vector2(120, 90)
	b.tooltip_text = "Повернуть по часовой" if clockwise else "Повернуть против часовой"
	var icon := Art.make_rot_icon(clockwise)
	icon.position = b.size / 2.0
	b.add_child(icon)
	b.pressed.connect(_rotate_ghost.bind(1 if clockwise else -1))
	ui.add_child(b)
	return b


func _hide_panels() -> void:
	pick_box.hide()
	place_btn.hide()
	rot_ccw_btn.hide()
	rot_cw_btn.hide()
	lobby_btn.hide()
	giveup_btn.hide()
	giveup_btn.text = "Сдаться"
	giveup_armed = 0.0
	finish_deadline = 0.0
	ghost.hide()
	info_label.text = ""
	center_label.text = ""


func _build_touch() -> void:
	touch_root = Node2D.new()
	ui.add_child(touch_root)
	var size := 130
	var tex := _circle_tex(size, Color(1, 1, 1, 0.28))
	var tex_down := _circle_tex(size, Color(1, 1, 1, 0.55))
	var defs := [
		["move_left", Vector2(30, 560), [Vector2(88, 35), Vector2(88, 95), Vector2(40, 65)], ""],
		["move_right", Vector2(190, 560), [Vector2(42, 35), Vector2(42, 95), Vector2(90, 65)], ""],
		["jump", Vector2(1120, 560), [Vector2(35, 88), Vector2(95, 88), Vector2(65, 40)], ""],
		["sprint", Vector2(970, 560), [], "Бег"],   # рядом с прыжком; у каждой кнопки свой палец (мультитач)
	]
	for d in defs:
		var b := TouchScreenButton.new()
		b.texture_normal = tex
		b.texture_pressed = tex_down
		b.action = d[0]
		b.position = d[1]
		var circle := CircleShape2D.new()
		circle.radius = size / 2.0
		b.shape = circle
		if d[3] == "":
			var tri := Polygon2D.new()
			tri.polygon = PackedVector2Array(d[2])
			tri.color = Color(1, 1, 1, 0.85)
			b.add_child(tri)
		else:
			var text := Label.new()
			text.text = d[3]
			text.size = Vector2(size, size)
			text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			text.add_theme_font_size_override("font_size", 34)
			text.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.6))
			text.add_theme_constant_override("outline_size", 5)
			b.add_child(text)
		touch_root.add_child(b)
		if d[0] == "sprint":
			sprint_btn = b
	touch_root.hide()


func _circle_tex(size: int, color: Color) -> ImageTexture:
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(size / 2.0, size / 2.0)
	for y in size:
		for x in size:
			if Vector2(x + 0.5, y + 0.5).distance_to(c) <= size / 2.0 - 1.0:
				img.set_pixel(x, y, color)
	return ImageTexture.create_from_image(img)


func _set_touch(on: bool) -> void:
	var touch := OS.has_feature("mobile") or DisplayServer.is_touchscreen_available()
	if OS.has_feature("web"):
		touch = bool(JavaScriptBridge.eval("('ontouchstart' in window) || navigator.maxTouchPoints > 0"))
	var show_it := on and touch
	touch_root.visible = show_it
	if not on:
		for a in ["move_left", "move_right", "jump", "sprint"]:
			Input.action_release(a)


# ======================================================================
#  Фазы раунда
# ======================================================================

func on_phase(p: int, data: Dictionary) -> void:
	phase = p
	grid.visible = p == Catalog.Phase.PLACE
	_hide_panels()
	_set_touch(false)
	_set_ported_active(p == Catalog.Phase.RUN)
	match p:
		Catalog.Phase.PICK:
			if int(Net.rules.map) != level_map:
				_set_map(int(Net.rules.map))
			round_no = data.round
			offer = data.offer
			picks = {}
			chosen = {}
			my_type = ""
			placed = false
			my_state = "idle"
			_set_deadline(data.time)
			_hide_players()
			_show_pick()
		Catalog.Phase.PLACE:
			chosen = data.chosen
			my_type = chosen.get(my_id, "")
			_set_deadline(data.time)
			turn_id = int(data.get("turn", 0))
			_show_placement()
		Catalog.Phase.RUN:
			var order: Array = data.order
			# общие часы ловушек: сколько прошло с начала забега по часам сервера, чтобы у всех стрелы и огонь совпадали
			_reset_coins()
			my_ghost = false
			player.modulate = Color.WHITE
			player.jump_scale = 1.0
			player.gravity_scale = 0.6 if Net.rules.gravity == "low" else 1.0
			player.sprint_allowed = bool(Net.rules.sprint)
			player.sprint_on = false
			player.dying = false
			player.dead = false
			player.success = false
			player.is_ghost = false
			player.last_killer = null
			player.reset_variables()
			run_clock = 0.0
			if Net.clock_synced() and data.has("started"):
				run_clock = clampf((Net.server_now_ms() - float(data.started)) / 1000.0, 0.0, 2.0)
			send_timer = 0.0
			_spawn_at(player, order.find(my_id))
			player.active = true
			player.visible = true
			my_state = "alive"
			for id in order:
				if id == my_id:
					continue
				var n := _ensure_remote(id)
				n.modulate = Color.WHITE
				n.position = _spawn_pos(order.find(id))
				n.visible = true
				remote_target[id] = n.position
			_set_touch(true)
			giveup_btn.show()
		_:
			pass


## Панель расстановки: мой ход (или все ставят сразу) — призрак и кнопки, иначе подсказка, кто ходит.
func _show_placement() -> void:
	ghost.hide()
	place_btn.hide()
	rot_ccw_btn.hide()
	rot_cw_btn.hide()
	if my_type == "":
		info_label.text = "Вы не успели выбрать блок"
	elif placed:
		info_label.text = "Блок поставлен. Ждём остальных…"
	elif turn_id != 0 and turn_id != my_id:
		info_label.text = "Ходит %s. Ждите своей очереди" % _name_of(turn_id)
	else:
		ghost_rot = 0
		_set_ghost_origin(ghost_origin)
		_refresh_ghost_visual()
		ghost.show()
		place_btn.show()
		rot_ccw_btn.show()
		rot_cw_btn.show()
		info_label.text = "%sБлок «%s»: коснитесь поля, чтобы выбрать место. A / D или стрелки внизу — повернуть" % [
			"Ваш ход! " if turn_id != 0 else "", Catalog.BLOCKS[my_type].name]


func _set_deadline(seconds: float) -> void:
	deadline = Time.get_ticks_msec() / 1000.0 + seconds


func _show_pick() -> void:
	for b in pick_box.get_children():
		b.queue_free()
	pick_buttons.clear()
	for i in offer.size():
		var info: Dictionary = Catalog.BLOCKS[offer[i]]
		var s: Vector2i = info.size
		var b := Button.new()
		b.custom_minimum_size = Vector2(220, 140)
		b.pressed.connect(func(): Net.pick(i))
		# значок блока сверху и подпись снизу: названия новых блоков сами по себе мало что говорят
		var icon := _make_visual(offer[i], info.color, "icon")
		var px := Vector2(s) * CELL
		var extent := 72.0 if info.kind == "pendulum" else maxf(px.x, px.y)    # у маятника шар торчит выше блока
		var k := clampf(56.0 / extent, 0.5, 1.4)
		icon.scale = Vector2(k, k)
		icon.position = Vector2(110, 46 if info.kind == "pendulum" else 42)
		b.add_child(icon)
		var caption := Label.new()
		caption.text = "%s\n%d×%d" % [info.name, s.x, s.y]
		caption.position = Vector2(0, 80)
		caption.size = Vector2(220, 56)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.add_theme_font_size_override("font_size", 22)
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(caption)
		b.set_meta("caption", caption)
		pick_box.add_child(b)
		pick_buttons.append(b)
	pick_box.show()
	info_label.text = "Выберите блок — берёт тот, кто нажал первым"


func _on_picks(p: Dictionary) -> void:
	picks = p
	for i in pick_buttons.size():
		var b: Button = pick_buttons[i]
		if not is_instance_valid(b) or not picks.has(i):
			continue
		b.disabled = true
		var caption: Label = b.get_meta("caption")
		caption.text = "%s\nвзял: %s" % [Catalog.BLOCKS[offer[i]].name, _name_of(picks[i])]
		if picks[i] == my_id:
			my_type = offer[i]
			info_label.text = "Вы взяли: %s. Ждём остальных…" % Catalog.BLOCKS[my_type].name


func _on_block_added(uid: int, owner_id: int, type: String, origin: Vector2i, rot: int) -> void:
	_spawn_block(uid, owner_id, type, origin, rot)
	if owner_id == my_id:
		_mark_placed("Блок поставлен. Ждём остальных…")


## Мой блок (или бомба) поставлен: убираем призрак и кнопки расстановки.
func _mark_placed(text: String) -> void:
	placed = true
	ghost.hide()
	place_btn.hide()
	rot_ccw_btn.hide()
	rot_cw_btn.hide()
	info_label.text = text


## Можно ли мне сейчас двигать призрака: фаза расстановки, блок выбран и не поставлен, а в классическом режиме — мой ход.
func _can_place_now() -> bool:
	return phase == Catalog.Phase.PLACE and not placed and my_type != "" and (turn_id == 0 or turn_id == my_id)


## Классический режим: ход перешёл к игроку player_id.
func _on_turn_changed(player_id: int, seconds: float) -> void:
	if phase != Catalog.Phase.PLACE:
		return
	turn_id = player_id
	_set_deadline(seconds)
	_show_placement()


func _on_place_rejected(msg: String) -> void:
	info_label.text = msg


func _on_round_finished(result: Dictionary, msg: String, reset_blocks: bool) -> void:
	phase = Catalog.Phase.RESULT
	_set_touch(false)
	_hide_players()
	player.active = false
	var lines: Array = [msg]
	for id in result:
		var r: Dictionary = result[id]
		if r.gain != 0:
			lines.append("%s: +%d  (%s)" % [_name_of(id), r.gain, ", ".join(r.notes)])
	center_label.text = "\n".join(lines)
	info_label.text = ""
	if reset_blocks:
		_clear_blocks()
	_set_deadline(Net.RESULT_TIME)


func _on_game_finished(winner_id: int) -> void:
	phase = Catalog.Phase.OVER
	center_label.text = "Победитель: %s!" % _name_of(winner_id)
	if Net.my_id == Net.host_id:
		lobby_btn.show()
	else:
		info_label.text = "Ждём, пока хозяин комнаты вернёт всех в лобби"


func _on_lobby(host: int, plist: Array) -> void:
	host_id = host
	players_info.clear()
	var lines: Array = []
	for p in plist:
		players_info[p.id] = p
		lines.append("%s: %d" % [p.name, p.score])
	score_label.text = "Цель: %d очков\n%s" % [Net.TARGET_SCORE, "\n".join(lines)]
	for id in remote_nodes.keys():
		if not players_info.has(id):
			remote_nodes[id].queue_free()
			remote_nodes.erase(id)
			remote_target.erase(id)


# ======================================================================
#  Игроки
# ======================================================================

func _color_of(id: int) -> Color:
	for p in Net.players:
		if p.id == id:
			return Catalog.PLAYER_COLORS[int(p.skin) % Catalog.PLAYER_COLORS.size()]
	return Color.WHITE


func _kind_of(id: int) -> int:
	for p in Net.players:
		if p.id == id:
			return int(p.skin) % Catalog.PLAYER_COLORS.size()
	return 0


func _name_of(id: int) -> String:
	if players_info.has(id):
		return players_info[id].name
	return "?"


func _spawn_pos(index: int) -> Vector2:
	var i := maxi(index, 0)
	# центр коллайдера: ноги стоят на крыше (клетка spawn.y + 1), запас в 1 px, чтобы не застрять в полу
	var spawn := Catalog.spawn_cell(level_map)
	return Vector2((spawn.x + i * 1.1) * CELL + CELL * 0.5,
		(spawn.y + 1) * CELL - Catalog.PLAYER_SIZE.y / 2.0 - 1.0)


func _spawn_at(who: Player, index: int) -> void:
	who.global_position = _spawn_pos(index)
	who.velocity = Vector2.ZERO


func _hide_players() -> void:
	player.visible = false
	player.active = false
	for id in remote_nodes:
		remote_nodes[id].visible = false


func _ensure_remote(id: int) -> Node2D:
	if remote_nodes.has(id) and is_instance_valid(remote_nodes[id]):
		return remote_nodes[id]
	var n := Node2D.new()
	n.add_child(SkinLibrary.make_sprite(SkinLibrary.skin_for_kind(_kind_of(id)), 0.2))
	var tag := Label.new()
	tag.text = _name_of(id)
	tag.position = Vector2(-50, -Catalog.PLAYER_SIZE.y / 2.0 - 24.0)   # над головой
	tag.size = Vector2(100, 24)
	tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tag.add_theme_font_size_override("font_size", 16)
	tag.add_theme_color_override("font_outline_color", Color.BLACK)
	tag.add_theme_constant_override("outline_size", 4)
	n.add_child(tag)
	n.visible = false
	remotes_root.add_child(n)
	remote_nodes[id] = n
	return n


func _on_peer_moved(id: int, pos: Vector2, vel: Vector2, _flip: bool) -> void:
	if phase != Catalog.Phase.RUN:
		return
	var n := _ensure_remote(id)
	if not n.visible:
		n.position = pos
		n.visible = true
	remote_target[id] = pos
	if absf(vel.x) > 10.0 and n.get_child_count() > 0:
		n.get_child(0).scale.x = 0.2 * (1.0 if vel.x > 0.0 else -1.0)
	if n.get_child_count() > 0 and n.get_child(0) is AnimatedSprite2D:
		var sp: AnimatedSprite2D = n.get_child(0)
		var a := "jump_up" if vel.y < -40.0 else ("jump_down" if vel.y > 40.0 else ("run" if absf(vel.x) > 10.0 else "idle"))
		if sp.animation != a:
			sp.play(a)


## Монеты подбираются заново в каждом забеге.
func _reset_coins() -> void:
	my_coins = 0
	for c in coin_nodes.values():
		if is_instance_valid(c):
			c.visible = true


func _on_coin_taken(uid: int, player_id: int) -> void:
	# свою монету не прячем — она летит за игроком; чужую берёт сервер, у всех остальных она пропадает
	if player_id != my_id and coin_nodes.has(uid) and is_instance_valid(coin_nodes[uid]):
		coin_nodes[uid].visible = false


func _on_coin_picked(_chr: Character, uid: int) -> void:
	if phase != Catalog.Phase.RUN or my_state != "alive":
		return
	my_coins += 1
	Net.send_coin(uid)


## Первый игрок дошёл до флага: у остальных идёт отсчёт.
func _on_run_countdown(seconds: float) -> void:
	if phase == Catalog.Phase.RUN:
		finish_deadline = Time.get_ticks_msec() / 1000.0 + seconds


func _on_player_status(id: int, status: String) -> void:
	if id == my_id or not remote_nodes.has(id):
		return
	var n: Node2D = remote_nodes[id]
	if status == "dead" and Net.rules.death != "out":
		n.modulate = Color(1, 1, 1, 0.45) if Net.rules.death == "ghost" else Color(0.55, 0.55, 0.55, 0.85)
	else:
		n.visible = false


# ======================================================================
#  Игровой процесс (забег)
# ======================================================================

func _on_block_touched(body: Node, uid: int, kind: String, rot: int) -> void:
	if body != player or phase != Catalog.Phase.RUN or my_state != "alive":
		return
	if kind == "hazard":
		_die(uid)


func _on_goal_entered(body: Node) -> void:
	if body == player:
		_finish()


## Финиш: флаг уровня или блок «Флаг» (GoalBlock) ставит персонажу success — отсюда общий путь.
func _on_player_succeeded() -> void:
	_finish()


func _finish() -> void:
	if phase != Catalog.Phase.RUN or my_state != "alive":
		return
	player.set_success(true)      # монета, которую несёт игрок, засчитывается
	my_state = "finished"
	player.active = false
	player.visible = false
	_set_touch(false)
	giveup_btn.hide()
	Net.send_finished()
	info_label.text = "Финиш! Ждём остальных…"


func _die(uid: int) -> void:
	if phase != Catalog.Phase.RUN or my_state != "alive":
		return
	_leave_run("Вы погибли. Ждём остальных…")
	Net.send_died(uid)


func _physics_process(delta: float) -> void:
	if phase != Catalog.Phase.RUN:
		return
	run_clock += delta
	for p in ported:      # общие часы забега: у всех игроков стрелы, огонь, качание и листья совпадают
		if is_instance_valid(p) and p is Placeable:
			p.sync_clock = run_clock
	if my_state != "alive" and not my_ghost:
		return
	if player.position.y > Catalog.GRID_H * CELL + 60:
		if my_ghost:
			player.global_position = _spawn_pos(0)    # призрак упал с карты — возвращаем к старту
			player.velocity = Vector2.ZERO
		else:
			_die(-1)
		return
	send_timer += delta
	if send_timer >= 0.05:
		send_timer = 0.0
		Net.send_state(player.position.x, player.position.y,
			player.velocity.x, player.velocity.y, player.facing < 0)


func _update_camera(delta: float) -> void:
	var follow := phase == Catalog.Phase.RUN and player.visible and (my_state == "alive" or my_ghost)
	var z := RUN_ZOOM if follow else 1.0
	cam.zoom = cam.zoom.lerp(Vector2(z, z), clampf(delta * 6.0, 0.0, 1.0))
	cam.position = cam.position.lerp(player.position if follow else VIEW_CENTER, clampf(delta * 10.0, 0.0, 1.0))


func _process(delta: float) -> void:
	_update_camera(delta)
	if sprint_btn:
		sprint_btn.modulate = Color(0.55, 1.0, 0.55, 1.0) if player.sprint_on else Color.WHITE
	for id in remote_nodes:
		var n: Node2D = remote_nodes[id]
		if n.visible and remote_target.has(id):
			n.position = n.position.lerp(remote_target[id], clampf(delta * 18.0, 0.0, 1.0))
	var left := maxf(0.0, deadline - Time.get_ticks_msec() / 1000.0)
	var names := {
		Catalog.Phase.PICK: "Выбор блока",
		Catalog.Phase.PLACE: "Расстановка",
		Catalog.Phase.RUN: "Забег!",
		Catalog.Phase.RESULT: "Итоги",
		Catalog.Phase.OVER: "Конец игры",
	}
	if phase == Catalog.Phase.OVER:
		sudden_ids = []
		top_label.text = "Конец игры"
	else:
		if phase == Catalog.Phase.RUN:
			if finish_deadline > 0.0:
				top_label.text = "Раунд %d · Забег! · осталось %d с" % [round_no, ceili(maxf(0.0, finish_deadline - Time.get_ticks_msec() / 1000.0))]
			else:
				top_label.text = "Раунд %d · Забег!" % round_no     # пока никто не дошёл, лимита времени нет
		else:
			top_label.text = "Раунд %d · %s · %d с" % [round_no, names.get(phase, ""), ceili(left)]
	if not sudden_ids.is_empty() and phase != Catalog.Phase.OVER:
		top_label.text += " · решающий раунд (%s)" % ", ".join(sudden_ids.map(func(i): return _name_of(i)))
	if _can_place_now():
		_update_ghost()


# ======================================================================
#  Расстановка блока
# ======================================================================

func _unhandled_input(event: InputEvent) -> void:
	if not _can_place_now():
		return
	# клавиши движения в фазе расстановки вращают блок: A / ← против часовой, D / → по часовой
	if event.is_action_pressed("move_left") and not event.is_echo():
		_rotate_ghost(-1)
		return
	if event.is_action_pressed("move_right") and not event.is_echo():
		_rotate_ghost(1)
		return
	var down := false
	if event is InputEventMouseButton:
		down = event.pressed and event.button_index == MOUSE_BUTTON_LEFT
	elif event is InputEventMouseMotion:
		down = (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0
	if down:
		_move_ghost(get_global_mouse_position())


func _set_ghost_origin(origin: Vector2i) -> void:
	var s := Catalog.size_of(my_type, ghost_rot)
	ghost_origin = Vector2i(
		clampi(origin.x, 0, Catalog.GRID_W - s.x),
		clampi(origin.y, 0, Catalog.GRID_H - 1 - s.y))


func _move_ghost(pos: Vector2) -> void:
	var s := Catalog.size_of(my_type, ghost_rot)
	_set_ghost_origin(Vector2i(roundi(pos.x / CELL - s.x / 2.0), roundi(pos.y / CELL - s.y / 2.0)))


## Поворот на четверть оборота (dir = 1 по часовой, -1 против); центр блока остаётся на месте.
func _rotate_ghost(dir: int) -> void:
	if not _can_place_now():
		return
	var old := Catalog.size_of(my_type, ghost_rot)
	var center := Vector2(ghost_origin) + Vector2(old) / 2.0
	ghost_rot = posmod(ghost_rot + dir, 4)
	var s := Catalog.size_of(my_type, ghost_rot)
	_set_ghost_origin(Vector2i(roundi(center.x - s.x / 2.0), roundi(center.y - s.y / 2.0)))
	_refresh_ghost_visual()


func _refresh_ghost_visual() -> void:
	if is_instance_valid(ghost_vis):
		ghost_vis.queue_free()
		ghost_vis = null
	if my_type == "":
		return
	ghost_vis = _rotated(_make_visual(my_type, Catalog.BLOCKS[my_type].color, "ghost"), ghost_rot)
	ghost.add_child(ghost_vis)


func _update_ghost() -> void:
	var s := Catalog.size_of(my_type, ghost_rot)
	ghost.position = Vector2(ghost_origin) * CELL
	ghost.size = Vector2(s) * CELL
	if is_instance_valid(ghost_vis):
		ghost_vis.position = ghost.size / 2.0
	# бомбу можно ставить поверх построек, но не на землю и не в запретные зоны
	var field: Dictionary = Catalog.static_occupied(level_map) if Catalog.BLOCKS[my_type].kind == "bomb" else occupied
	var ok := Catalog.can_place(my_type, ghost_origin, field, ghost_rot)
	ghost.color = Color(0.2, 0.9, 0.3, 0.3) if ok else Color(0.95, 0.2, 0.2, 0.3)
	if is_instance_valid(ghost_vis):
		ghost_vis.modulate = Color(0.75, 1.0, 0.75, 0.85) if ok else Color(1.0, 0.55, 0.55, 0.85)
	place_btn.disabled = not ok
