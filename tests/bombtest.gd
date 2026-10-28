extends Node
## Бомбы и ловушки на клиенте. Взрыв приходит от сервера при установке бомбы (сообщение boom), клиент сносит блоки насовсем;
## арбалет, огнемёт и маятник считаются по часам забега.
## Время двигаем вручную (_tick_*), поэтому результат не зависит от скорости кадров.
##   godot --headless --path . tests/bombtest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	check(Catalog.size_of("dynamite") == Vector2i(1, 1) and Catalog.size_of("bomb") == Vector2i(2, 2) and Catalog.size_of("nuke") == Vector2i(3, 3), "зоны бомб 1×1, 2×2, 3×3")
	check(Catalog.size_of("crossbow") == Vector2i(2, 1) and Catalog.size_of("crossbow", 1) == Vector2i(1, 2), "арбалет 2×1, повёрнутый 1×2")

	var g: Node2D = load("res://scripts/game.gd").new()
	add_child(g)
	await get_tree().process_frame
	var run := {"order": [g.my_id], "time": 0.0}

	# ---- сервер сообщил о взрыве при установке: постройки в зоне исчезают насовсем, остальные целы ----
	g._spawn_block(2, 2, "plank", Vector2i(13, 13))
	g._spawn_block(3, 2, "plank", Vector2i(24, 8))
	g._spawn_block(4, 2, "spikes", Vector2i(12, 13))
	check(g.occupied.has(Vector2i(13, 13)), "клетки доски заняты")
	g.on_phase(Catalog.Phase.PLACE, {"chosen": {g.my_id: "dynamite"}, "time": 25.0})
	g._on_boom(1, 99, "dynamite", Rect2i(11, 12, 3, 3), [2, 4])
	check(not g.block_nodes.has(2) and not g.block_nodes.has(4), "доска и шипы в зоне исчезли")
	check(g.block_nodes.has(3) and not g.block_defs.has(2) and g.block_defs.size() == 1, "блок вне зоны цел, снесённое не восстанавливается")
	check(not g.occupied.has(Vector2i(13, 13)) and g.occupied.has(Vector2i(24, 8)), "клетки снесённого свободны, остальные заняты")
	check(Catalog.can_place("plank", Vector2i(13, 13), g.occupied), "на месте снесённой доски снова можно строить")
	check(g.block_nodes.size() == 1, "сама бомба на уровне не появилась")

	# бомбу можно целить поверх построек, но не на землю
	g._spawn_block(5, 2, "plank", Vector2i(20, 8))
	g.my_type = "bomb"
	g._set_ghost_origin(Vector2i(20, 8))
	g._update_ghost()
	check(not g.place_btn.disabled, "бомбу можно поставить на постройку")
	g._set_ghost_origin(Vector2i(2, 17))     # земля у старта
	g._update_ghost()
	check(g.place_btn.disabled, "на землю бомбу ставить нельзя")
	g.my_type = "plank"
	g._set_ghost_origin(Vector2i(20, 8))
	g._update_ghost()
	check(g.place_btn.disabled, "обычный блок на постройку по-прежнему нельзя")

	# ядерный взрыв: большая зона, вспышка не ломает сцену
	g._on_boom(6, 99, "nuke", Rect2i(18, 6, 8, 8), [3, 5])
	check(g.block_nodes.is_empty(), "ядерный взрыв снёс всё в своей зоне")

	# взрыв не убивает игрока: бомбы работают только в фазе строительства
	g.on_phase(Catalog.Phase.RUN, run)
	check(g.my_state == "alive", "после взрывов игрок жив")

	# ---- ловушки ----
	g._on_round_finished({}, "тест", true)
	g._spawn_block(10, 2, "crossbow", Vector2i(24, 10), 1)        # смотрит вправо
	g._spawn_block(11, 2, "flamethrower", Vector2i(4, 27), 0)     # огонь вверх, прямо под стартом
	g._spawn_block(12, 2, "pendulum", Vector2i(30, 6), 0)
	check(g.traps.size() == 3, "ловушки зарегистрированы")
	g.on_phase(Catalog.Phase.RUN, run)
	var cb: Dictionary = g.traps[0]
	g.run_clock = 0.9
	g._tick_traps(0.016)
	check(_arrows(cb.node).is_empty(), "арбалет ещё не выстрелил (первый выстрел через 1 с)")
	g.run_clock = 1.05
	g._tick_traps(0.016)
	var arrows := _arrows(cb.node)
	check(arrows.size() == 1, "арбалет выстрелил")
	var x0: float = arrows[0].position.x
	g._tick_traps(0.1)
	check(arrows[0].position.x > x0 + 20.0, "стрела летит вправо (%.0f → %.0f)" % [x0, arrows[0].position.x])
	check(absf(arrows[0].position.y) < 0.01, "стрела летит по прямой")
	g.run_clock = 1.05 + Catalog.BLOCKS.crossbow.period + 0.01
	g._tick_traps(0.016)
	check(_arrows(cb.node).size() == 2, "второй выстрел через period")
	# стрела, попавшая в игрока, убивает (хозяину ловушки очки даст сервер)
	g._on_arrow_hit(g.player, _arrows(cb.node)[0], 10)
	check(g.my_state == "dead", "стрела убила игрока")
	g.on_phase(Catalog.Phase.RUN, run)
	check(_arrows(cb.node).is_empty() and g.my_state == "alive", "новый забег: стрелы убраны")
	# стрела улетает за карту и исчезает
	g.run_clock = 1.05
	g._tick_traps(0.016)
	for i in 60:
		g._tick_traps(0.1)
	await get_tree().process_frame
	check(_arrows(cb.node).is_empty(), "стрела за краем карты удалена")

	# огнемёт: огонь горит по расписанию и жжёт того, кто в струе
	var fl: Dictionary = g.traps[1]
	g.on_phase(Catalog.Phase.RUN, run)
	g.run_clock = 1.5   # fmod(1.5 + 0.7*uid, 3.4) с uid=11 → вне окна огня
	var off_clock := 0.0
	var on_clock := 0.0
	for c in range(0, 340):
		var t := c / 100.0
		var on := fmod(t + fl.phase, float(Catalog.BLOCKS.flamethrower.period)) < float(Catalog.BLOCKS.flamethrower.on)
		if on and on_clock == 0.0:
			on_clock = t + 0.05
		if not on and off_clock == 0.0:
			off_clock = t + 0.05
	g.run_clock = off_clock
	g._tick_traps(0.016)
	check(not fl.flame.visible and g.my_state == "alive", "огнемёт между вспышками безвреден")
	g.run_clock = on_clock
	g._tick_traps(0.016)
	check(fl.flame.visible, "огнемёт горит")
	check(g.my_state == "dead", "игрок в струе огня погиб")

	# маятник: шар качается и бьёт
	g.on_phase(Catalog.Phase.RUN, run)
	var pd: Dictionary = g.traps[2]
	g.run_clock = 0.5
	g._tick_traps(0.016)
	var want: float = sin(0.5 * float(Catalog.BLOCKS.pendulum.freq) + pd.phase) * deg_to_rad(float(Catalog.BLOCKS.pendulum.swing))
	check(absf(pd.vis.rod_angle - want) < 0.001, "угол маятника по часам забега")
	check(g.my_state == "alive", "маятник далеко — игрок жив")
	g.player.global_position = pd.node.position + pd.dir.rotated(pd.vis.rod_angle) * float(Catalog.BLOCKS.pendulum.arm) * Catalog.CELL
	g._tick_traps(0.0)
	check(g.my_state == "dead", "шар маятника убил игрока")

	# взрыв сносит и ловушку вместе с её стрелами
	g.on_phase(Catalog.Phase.RUN, run)
	g.run_clock = 1.05
	g._tick_traps(0.016)
	check(_arrows(cb.node).size() == 1, "стрела есть")
	g._on_boom(5, 99, "bomb", Rect2i(23, 9, 4, 3), [10])
	check(g.traps.size() == 2 and not g.block_nodes.has(10), "снесённый арбалет убран из ловушек")

	g._on_round_finished({}, "тест", true)
	check(g.block_nodes.is_empty() and g.traps.is_empty() and g.block_defs.is_empty(), "после засчитанного раунда уровень пуст")

	print("BOMBTEST: ошибок=%d" % failures)
	get_tree().quit(1 if failures > 0 else 0)


func _arrows(node: Node) -> Array:
	return node.get_children().filter(func(c): return c.has_meta("arrow") and not c.is_queued_for_deletion())
