extends Node
## Проверка всех четырёх уровней: игрок встаёт на землю у старта, платформы твёрдые, опасные зоны убивают, флаг засчитывает финиш.
## Пройти уровень без блоков нельзя (в этом смысл игры), поэтому финиш и смерть проверяем телепортом в нужную зону.
##   godot --headless --path . tests/walktest.tscn

var g: Node2D
var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	g = load("res://scripts/game.gd").new()
	add_child(g)
	await get_tree().process_frame
	for map in Catalog.MAPS.size():
		var name: String = Catalog.MAPS[map].name
		Net.rules["map"] = map
		g.on_phase(Catalog.Phase.PICK, {"round": 1, "offer": ["plank", "box", "pillar", "nuke"], "time": 15.0})
		check(g.level_map == map and g.roofs_root.get_child_count() >= Catalog.MAPS[map].rects.size(), "%s: уровень построен" % name)

		# старт: все четверо встают на землю под спавном
		g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id, 2, 3, 4], "time": 0.0})
		for i in 20:
			await get_tree().physics_frame
		var feet: float = g.player.position.y + Catalog.PLAYER_SIZE.y / 2.0
		var ground: float = (Catalog.spawn_cell(map).y + 1) * Catalog.CELL
		check(g.player.is_on_floor() and absf(feet - ground) < 2.0, "%s: игрок стоит на земле (ноги %.0f, земля %.0f)" % [name, feet, ground])
		for i in 4:
			var pos: Vector2 = g._spawn_pos(i)
			check(pos.x > 0.0 and pos.x < 12 * Catalog.CELL, "%s: спавн %d над стартовой землёй (x=%.0f)" % [name, i, pos.x])

		# каждая платформа твёрдая: игрок, поставленный над ней, на ней остаётся
		for r: Rect2i in Catalog.MAPS[map].rects:
			if r.size.x < 3 or r.position.y < 4 or _headroom_blocked(map, r):
				continue
			g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0.0})   # заново живой: прошлая проверка могла убить
			g.player.global_position = Vector2((r.position.x + r.size.x / 2.0) * Catalog.CELL, r.position.y * Catalog.CELL - Catalog.PLAYER_SIZE.y / 2.0 - 4.0)
			g.player.velocity = Vector2.ZERO
			for i in 12:
				await get_tree().physics_frame
			check(g.my_state == "alive" and g.player.is_on_floor(), "%s: платформа %s держит игрока" % [name, r])

		# опасные зоны убивают (на самой земле под шипами и слизью игрок гибнет — так и должно быть)
		for h: Rect2i in Catalog.MAPS[map].hazards:
			g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0.0})
			g.player.global_position = (Vector2(h.position) + Vector2(h.size) / 2.0) * Catalog.CELL
			for i in 6:
				await get_tree().physics_frame
			check(g.my_state == "dead", "%s: опасная зона %s убивает" % [name, h])

		# флаг: касание засчитывает финиш
		g.on_phase(Catalog.Phase.RUN, {"order": [g.my_id], "time": 0.0})
		var goal := Catalog.goal_cell(map)
		g.player.global_position = Vector2(goal.x * Catalog.CELL + Catalog.CELL / 2.0, goal.y * Catalog.CELL)
		for i in 6:
			await get_tree().physics_frame
		check(g.my_state == "finished", "%s: касание флага — финиш (состояние %s)" % [name, g.my_state])
		g.player.global_position = g._spawn_pos(0)    # уводим игрока с флага: на следующей карте флаг стоит в той же клетке
		for i in 4:
			await get_tree().physics_frame
		print("WALK: %s проверен" % name)
	print("WALKTEST: ошибок=%d" % failures)
	get_tree().quit(1 if failures > 0 else 0)


## Над платформой меньше двух клеток свободного места (на ней лежит другая платформа): встать на неё нельзя.
func _headroom_blocked(map: int, r: Rect2i) -> bool:
	for o: Rect2i in Catalog.MAPS[map].rects:
		if o != r and o.position.x < r.end.x and o.end.x > r.position.x and o.end.y > r.position.y - 2 and o.end.y <= r.position.y:
			return true
	return false
