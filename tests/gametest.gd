extends Node
## Дымовой тест клиентской сцены без сети: строит мир, ставит все типы блоков (во всех поворотах),
## проверяет поворот призрака, бег и пружины, запускает забег.
##   godot --headless --path . tests/gametest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	# ---- каталог: поворот меняет размер и проверку размещения ----
	check(Catalog.size_of("plank") == Vector2i(3, 1), "plank 3×1")
	check(Catalog.size_of("plank", 1) == Vector2i(1, 3) and Catalog.size_of("plank", 3) == Vector2i(1, 3), "plank rot 1/3 → 1×3")
	check(Catalog.size_of("plank", 2) == Vector2i(3, 1), "plank rot 2 → 3×1")
	check(not Catalog.can_place("plank", Vector2i(Catalog.GRID_W - 2, 5), {}, 0), "plank 3×1 не влезает у края")
	check(Catalog.can_place("plank", Vector2i(Catalog.GRID_W - 1, 5), {}, 1), "plank 1×3 влезает у края")
	check(not Catalog.can_place("plank", Vector2i(5, Catalog.GRID_H - 3), {}, 1), "plank 1×3 выходит за землю")
	check(not Catalog.can_place("plank", Vector2i(5, 5), {}, 4), "rot 4 недопустим")
	check(Catalog.facing_of(0) == Vector2.UP and Catalog.facing_of(1) == Vector2.RIGHT
		and Catalog.facing_of(2) == Vector2.DOWN and Catalog.facing_of(3) == Vector2.LEFT, "направления пружины")

	var g: Node2D = load("res://scripts/game.gd").new()
	add_child(g)
	await get_tree().process_frame
	g.on_phase(Catalog.Phase.PICK, {"round": 1, "offer": ["plank", "spikes", "saw", "spring", "mover"], "time": 15.0})
	await get_tree().process_frame
	g.on_phase(Catalog.Phase.PLACE, {"chosen": {g.my_id: "pillar"}, "time": 25.0})
	g._move_ghost(Vector2(400, 200))
	await get_tree().process_frame

	# ---- поворот призрака (кнопки и клавиши вызывают _rotate_ghost) ----
	var before: Vector2i = g.ghost_origin
	check(g.ghost.size == Vector2(Catalog.CELL, Catalog.CELL * 3), "призрак карандаша 1×3 до поворота: %s" % g.ghost.size)
	g._rotate_ghost(1)
	await get_tree().process_frame
	check(g.ghost_rot == 1 and g.ghost.size == Vector2(Catalog.CELL * 3, Catalog.CELL), "после ↻: rot=1, размер 3×1 (%s)" % g.ghost.size)
	var c0 := Vector2(before) + Vector2(0.5, 1.5)
	var c1 := Vector2(g.ghost_origin) + Vector2(1.5, 0.5)
	check(c0 == c1, "центр блока не уехал при повороте: %s → %s" % [c0, c1])
	g._rotate_ghost(-1)
	g._rotate_ghost(-1)
	check(g.ghost_rot == 3, "↺ два раза от 1 даёт 3")
	g._rotate_ghost(1)
	await get_tree().process_frame
	check(g.ghost_rot == 0 and g.ghost.size == Vector2(Catalog.CELL, Catalog.CELL * 3), "полный круг возвращает исходное")
	# у края поля повёрнутый блок прижимается внутрь сетки
	g._move_ghost(Vector2(Catalog.GRID_W * 32 - 10, 100))
	g._rotate_ghost(1)
	check(g.ghost_origin.x + Catalog.size_of("pillar", 1).x <= Catalog.GRID_W, "повёрнутый призрак не вылезает за правый край")
	# реальные клавиши: A / D вращают блок в фазе расстановки
	var ev := InputEventAction.new()
	ev.action = "move_right"
	ev.pressed = true
	var rot_before: int = g.ghost_rot
	g._unhandled_input(ev)
	check(g.ghost_rot == (rot_before + 1) % 4, "D вращает по часовой")
	ev.action = "move_left"
	g._unhandled_input(ev)
	check(g.ghost_rot == rot_before, "A вращает против часовой")

	# ---- все блоки во всех поворотах ----
	var uid := 0
	var x := 1
	for t in ["plank", "box", "pillar", "spikes", "saw", "spring", "mover"]:
		for rot in 4:
			uid += 1
			var sz := Catalog.size_of(t, rot)
			var origin := Vector2i(x, 2)
			g._spawn_block(uid, 1, t, origin, rot)
			check(Catalog.can_place(t, origin, {}, rot), "%s rot %d помещается в сетку" % [t, rot])
			x += sz.x + 1
			if x > 34:
				x = 1
	# новые блоки (бомбы и ловушки) во всех поворотах — справа, подальше от точки старта игрока
	var nx := 22
	for t in ["dynamite", "bomb", "nuke", "crossbow", "flamethrower", "pendulum", "coin"]:
		for rot in 4:
			uid += 1
			var sz := Catalog.size_of(t, rot)
			var origin := Vector2i(nx, 2)
			g._spawn_block(uid, 1, t, origin, rot)
			check(Catalog.can_place(t, origin, {}, rot), "%s rot %d помещается в сетку" % [t, rot])
			nx += sz.x + 1
			if nx > 34:
				nx = 22
	check(g.block_nodes.size() == uid, "созданы все блоки (%d)" % uid)
	check(Catalog.BLOCKS.size() == 20, "в каталоге 20 блоков")
	# лифт (повёрнутый листок) ездит по вертикали, обычный листок — по горизонтали
	var axes := {}
	for m in g.movers:
		axes[m.axis] = true
	check(axes.has(Vector2.RIGHT) and axes.has(Vector2.DOWN), "листок: горизонтальный и вертикальный (лифт)")

	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 45.0})
	for i in 90:
		await get_tree().physics_frame
	var p: Player = g.player
	var want_y: float = (Catalog.spawn_cell(0).y + 1) * Catalog.CELL - Catalog.PLAYER_SIZE.y / 2.0
	print("TEST: блоков=%d, игрок y=%.1f (ожидаем ~%.0f на крыше), состояние=%s" % [g.block_nodes.size(), p.position.y, want_y, g.my_state])
	check(p.is_on_floor() and absf(p.position.y - want_y) < 1.5, "персонаж 1×2 стоит на крыше, ноги на полу")
	check(g.my_state == "alive", "жив после появления")

	# ---- бег: заметно быстрее обычной ходьбы ----
	var normal_vx := await _run_speed(g, false)
	var sprint_vx := await _run_speed(g, true)
	print("TEST: скорость ходьбы=%.0f, бега=%.0f (×%.2f)" % [normal_vx, sprint_vx, sprint_vx / normal_vx])
	check(absf(normal_vx - Player.SPEED) < 5.0, "обычная скорость = SPEED")
	check(sprint_vx / normal_vx > 1.5 and sprint_vx / normal_vx < 1.6, "бег ×1.5–1.6")
	# повторное нажатие выключает бег (он переключается, а не удерживается) — возвращаемся к обычной скорости
	check(p.sprint_on, "бег остался включённым после отпускания кнопки")
	Input.action_press("sprint")
	await get_tree().physics_frame
	await get_tree().physics_frame
	Input.action_release("sprint")
	check(not p.sprint_on, "второе нажатие выключило бег")
	Input.action_press("move_right")
	for i in 40:
		await get_tree().physics_frame
	check(absf(p.velocity.x - Player.SPEED) < 5.0, "после отпускания бега скорость вернулась к обычной (%.0f)" % p.velocity.x)
	Input.action_release("move_right")

	# длинный пол за стартом: на картах между платформами пропасть, а тесту бега нужна земля под ногами
	var floor_body := StaticBody2D.new()
	g._fill_body(floor_body, Rect2i(6, 18, 32, 4), Color.WHITE)
	g.blocks_root.add_child(floor_body)

	# ---- импульс бега сохраняется: в воздухе почти не теряется, при приземлении скорость не обнуляется ----
	_reset_player(g)
	for i in 3:
		await get_tree().physics_frame
	Input.action_press("move_right")
	Input.action_press("sprint")
	for i in 20:
		await get_tree().physics_frame
	Input.action_press("jump")
	for i in 3:
		await get_tree().physics_frame
	Input.action_release("jump")
	Input.action_release("sprint")
	await get_tree().physics_frame
	Input.action_press("sprint")             # бег переключается: второе нажатие в воздухе выключает его
	await get_tree().physics_frame
	await get_tree().physics_frame
	Input.action_release("sprint")
	for i in 8:
		await get_tree().physics_frame
	check(not p.is_on_floor() and p.velocity.x > Player.SPEED * 1.25, "в воздухе импульс бега почти не теряется (%.0f)" % p.velocity.x)
	var guard := 0
	while not p.is_on_floor() and guard < 120:
		await get_tree().physics_frame
		guard += 1
	check(p.velocity.x >= Player.SPEED - 5.0, "приземлились на ходу, скорость не обнулилась (%.0f)" % p.velocity.x)
	Input.action_release("move_right")

	# приземление с зажатым бегом: скорость бега остаётся
	_reset_player(g)
	for i in 3:
		await get_tree().physics_frame
	Input.action_press("move_right")
	Input.action_press("sprint")
	for i in 14:
		await get_tree().physics_frame
	Input.action_press("jump")
	for i in 3:
		await get_tree().physics_frame
	Input.action_release("jump")
	guard = 0
	while not p.is_on_floor() and guard < 120:
		await get_tree().physics_frame
		guard += 1
	check(p.is_on_floor() and p.velocity.x > Player.SPEED * 1.5, "приземлились с бегом — скорость бега сохранилась (%.0f)" % p.velocity.x)
	Input.action_release("move_right")
	Input.action_release("sprint")

	# ---- пружины: толчок в сторону поворота ----
	_reset_player(g)
	p.bounce(820.0)
	check(p.velocity.y == -820.0, "пружина вверх")
	p.bounce(820.0, Vector2.RIGHT)
	check(p.velocity.x == 820.0 and p.velocity.y <= -Player.SIDE_BOUNCE_LIFT, "пружина вправо")
	p.bounce(820.0, Vector2.LEFT)
	check(p.velocity.x == -820.0, "пружина влево")
	p.bounce(820.0, Vector2.DOWN)
	check(p.velocity.y == 820.0, "пружина вниз")

	# ---- старый смоук: бег и прыжок программно ----
	_reset_player(g)
	for i in 3:
		await get_tree().physics_frame
	Input.action_press("move_right")
	Input.action_press("jump")
	for i in 30:
		await get_tree().physics_frame
	Input.action_release("jump")
	Input.action_release("move_right")
	print("TEST: после бега x=%.1f y=%.1f" % [p.position.x, p.position.y])
	# ---- монета: подбирается касанием один раз за забег, у других прячется по сообщению сервера, в новом забеге возвращается ----
	g._spawn_block(900, 1, "coin", Vector2i(30, 3))
	g._spawn_block(901, 1, "coin", Vector2i(32, 3))
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	check(g.coin_nodes[900].visible and g.coin_nodes[901].visible, "монеты видны в начале забега")
	g._on_block_touched(g.player, 900, "coin", 0)
	g._on_block_touched(g.player, 900, "coin", 0)
	check(not g.coin_nodes[900].visible and g.my_coins == 1, "подобрана один раз (%d)" % g.my_coins)
	g._on_coin_taken(901, 99)
	check(not g.coin_nodes[901].visible and g.my_coins == 1, "чужая монета спрятана, моя не засчитана")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	check(g.coin_nodes[900].visible and g.coin_nodes[901].visible and g.my_coins == 0, "новый забег: монеты на месте")

	# ---- «Сдаться»: нужно подтверждение, после него игрок выбывает; отсчёт после первого финиша виден ----
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	check(g.giveup_btn.visible and g.my_state == "alive", "в забеге есть кнопка «Сдаться»")
	g._on_giveup_pressed()
	check(g.my_state == "alive" and g.giveup_btn.text == "Точно?", "первое нажатие только спрашивает подтверждение")
	g._on_run_countdown(20.0)
	g._process(0.0)
	check(g.top_label.text.contains("осталось 20") or g.top_label.text.contains("осталось 19"), "отсчёт после первого финиша: %s" % g.top_label.text)
	g._on_giveup_pressed()
	check(g.my_state == "dead" and not g.player.visible and not g.giveup_btn.visible, "второе нажатие — сдался")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	g._process(0.0)
	check(g.my_state == "alive" and not g.top_label.text.contains("осталось") and g.giveup_btn.text == "Сдаться", "новый забег: отсчёт и кнопка сброшены")

	# ---- классический режим: призрак и кнопки только на своём ходу; бомба убирает панель расстановки ----
	var saved_id: int = g.my_id
	g.my_id = 3                        # у настоящих игроков id начинаются с 1 (0 в turn значит «все сразу»)
	g.on_phase(Catalog.Phase.PLACE, {"chosen": {g.my_id: "plank"}, "time": 15.0, "turn": 4})
	check(not g.ghost.visible and not g.place_btn.visible and g.info_label.text.contains("Ходит"), "чужой ход: призрака нет, показано, кто ходит")
	g._on_turn_changed(g.my_id, 15.0)
	check(g.ghost.visible and g.place_btn.visible and g.info_label.text.contains("Ваш ход"), "мой ход: призрак и кнопка «Поставить»")
	g._on_turn_changed(4, 15.0)
	check(not g.ghost.visible and not g.place_btn.visible, "ход ушёл — призрак убран")
	g.on_phase(Catalog.Phase.PLACE, {"chosen": {g.my_id: "bomb"}, "time": 25.0})
	check(g.ghost.visible and g.place_btn.visible and g.turn_id == 0, "Party: все ставят сразу")
	g._on_boom(5, g.my_id, "bomb", Rect2i(30, 3, 2, 2), [])
	check(g.placed and not g.ghost.visible and not g.place_btn.visible, "моя бомба взорвалась — панель расстановки убрана")
	g.my_id = saved_id

	# ---- правила: призрак и труп продолжают двигаться, не гибнут повторно; низкая гравитация и «без бега» доходят до игрока ----
	Net._set_rules({"death": "ghost", "gravity": "low", "sprint": false, "target": 20.0, "accumulate": false, "offer": 5.0})
	check(Net.rules.target == 20 and typeof(Net.rules.target) == TYPE_INT and Net.TARGET_SCORE == 20, "правила: числа приведены к int, цель очков обновилась")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	check(absf(g.player.gravity_scale - 0.6) < 0.001 and not g.player.sprint_allowed, "низкая гравитация и бег выключен")
	g._die(-1)
	check(g.my_state == "dead" and g.my_ghost and g.player.visible and g.player.active, "призрак: погиб, но продолжает двигаться")
	check(g.player.modulate.a < 0.6, "призрак полупрозрачный")
	g._on_block_touched(g.player, 1, "hazard", 0)
	g._on_goal_entered(g.player)
	check(g.my_state == "dead", "призрак не гибнет повторно и не финиширует")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	check(g.my_state == "alive" and not g.my_ghost and g.player.modulate.a == 1.0, "новый забег: снова живой")
	Net._set_rules({"death": "corpse"})
	g._die(-1)
	check(g.my_ghost and absf(g.player.jump_scale - 0.6) < 0.001 and not g.player.sprint_allowed, "труп: прыжок ниже, бега нет")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	Net._set_rules({"death": "out"})
	g._die(-1)
	check(g.my_state == "dead" and not g.my_ghost and not g.player.visible, "«выбывает»: игрок исчезает")
	g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0})
	Net._set_rules({"death": "ghost"})
	g._on_giveup_pressed()
	g._on_giveup_pressed()
	check(g.my_state == "dead" and not g.my_ghost and not g.player.visible, "сдавшийся призраком не становится")
	Net._set_rules({"death": "out", "gravity": "normal", "sprint": true, "target": 30.0, "accumulate": true, "offer": 4.0})

	print("GAMETEST: ошибок=%d" % failures)
	get_tree().quit(1 if failures > 0 else 0)


func _reset_player(g: Node2D) -> void:
	g.player.sprint_on = false
	g.player.global_position = g._spawn_pos(0)
	g.player.velocity = Vector2.ZERO


## Разгоняемся с места на крыше 20 кадров и возвращаем горизонтальную скорость.
func _run_speed(g: Node2D, sprint: bool) -> float:
	_reset_player(g)
	for i in 3:
		await get_tree().physics_frame
	Input.action_press("move_right")
	if sprint:
		Input.action_press("sprint")
	for i in 20:
		await get_tree().physics_frame
	var vx: float = g.player.velocity.x
	Input.action_release("move_right")
	Input.action_release("sprint")
	return vx
