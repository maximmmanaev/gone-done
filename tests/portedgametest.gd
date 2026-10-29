extends Node
## Блоки из scripts/ported внутри настоящей игры: лёд, мёд, яд, пила на рельсе, топор, ветер.
##   godot --headless --path . tests/portedgametest.tscn

var failures := 0
var g: Node2D


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _frames(n: int) -> void:
	for i in n:
		await get_tree().physics_frame


func _run_phase() -> void:
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id, 2, 3, 4], "time": 0.0})


func _put(pos: Vector2) -> void:
	g.player.global_position = pos
	g.player.velocity = Vector2.ZERO


func _ready() -> void:
	g = load("res://scripts/game.gd").new()
	add_child(g)
	await get_tree().process_frame
	g.on_phase(Catalog.Phase.PICK, {"round": 1, "offer": ["plank", "ice", "honey", "toxic"], "time": 15.0})
	# длинный пол выше карты, чтобы тест не зависел от уровня
	var floor_body := StaticBody2D.new()
	var sh := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(2000, 20)
	sh.shape = rs
	floor_body.collision_layer = 1
	floor_body.position = Vector2(640, 200)
	floor_body.add_child(sh)
	add_child(floor_body)

	# каждый из шести блоков создаётся во всех четырёх поворотах без ошибок
	var uid := 100
	for t in Catalog.PORTED_KINDS:
		for rot in 4:
			uid += 1
			g._spawn_block(uid, 7, t, Vector2i(2 + rot * 8, 20), rot)
	check(g.ported.size() == 24, "24 блока ported создано (%d)" % g.ported.size())
	g._clear_blocks()
	check(g.ported.is_empty(), "очистка убрала ported")

	# --- лёд: над верхней гранью платформы трение падает
	g._spawn_block(1, 7, "ice", Vector2i(10, 8), 0)      # верх платформы на y=128
	_run_phase()
	_put(Vector2(10 * 16 + 24, 128 - 15))
	await _frames(8)
	check(g.player.physics_modifiers.size() == 1 and g.player.ground_friction_modifier < 0.2, "лёд: трение %.2f" % g.player.ground_friction_modifier)
	g._clear_blocks()

	# --- мёд
	g._spawn_block(2, 7, "honey", Vector2i(10, 8), 0)
	_run_phase()
	_put(Vector2(10 * 16 + 24, 128 - 15))
	await _frames(8)
	check(g.player.run_speed_modifier < 1.0 and g.player.jump_force_modifier < 1.0, "мёд: бег %.2f, прыжок %.2f" % [g.player.run_speed_modifier, g.player.jump_force_modifier])
	g._clear_blocks()

	# --- яд убивает, uid хозяйского блока доходит до _die
	g._spawn_block(3, 7, "toxic", Vector2i(20, 8), 0)
	_run_phase()
	await _frames(2)
	var killed_uid := [-2]
	g.player.died.connect(func(_c): killed_uid[0] = int(g.player.last_killer.get_meta("uid")) if is_instance_valid(g.player.last_killer) else -1)
	_put(Vector2(20 * 16 + 16, 8 * 16 + 8))
	await _frames(6)
	check(g.my_state != "alive" and killed_uid[0] == 3, "яд убил игрока, uid=%d, состояние=%s" % [killed_uid[0], g.my_state])
	g._clear_blocks()

	# --- следующий забег: состояние смерти сбросилось, игрок снова живой и двигается
	_run_phase()
	await _frames(3)
	check(g.my_state == "alive" and not g.player.dying and not g.player.dead, "новый забег: игрок жив (%s dying=%s dead=%s active=%s cause=%s pos=%s)" % [g.my_state, g.player.dying, g.player.dead, g.player.active, g.player.last_death, g.player.position])

	# --- пила на рельсе ездит и убивает
	g._spawn_block(4, 7, "sawrail", Vector2i(30, 8), 0)
	_run_phase()
	var saw: LinearSaw = g.ported[0]
	var x0 := saw.position.x
	await _frames(30)
	check(absf(saw.position.x - x0) > 5.0, "пила едет по рельсе (%.1f → %.1f)" % [x0, saw.position.x])
	_put(Vector2(0, 0))
	g._clear_blocks()

	# --- ветер толкает
	g.my_state = "alive"
	g._spawn_block(5, 7, "wind", Vector2i(10, 4), 1)     # дует вправо
	_run_phase()
	_put(Vector2(10 * 16 + 24, 128 - 15))
	var xs: float = g.player.position.x
	await _frames(25)
	check(g.player.position.x > xs + 3.0, "ветер сдувает вправо (%.1f → %.1f)" % [xs, g.player.position.x])
	g._clear_blocks()

	# --- вне забега всё стоит
	g.on_phase(Catalog.Phase.PICK, {"round": 2, "offer": ["plank"], "time": 15.0})
	g._spawn_block(6, 7, "sawrail", Vector2i(30, 8), 0)
	await _frames(20)
	var s2: LinearSaw = g.ported[0]
	check(not s2.is_active and s2.position.x == s2.start_origin.x, "пила стоит вне забега")

	print("portedgametest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
