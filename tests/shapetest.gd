extends Node
## Новые предметы инвентаря: составные формы (лестница, балка, камни), повороты и осмотр всех блоков в игре.
##   godot --headless --path . tests/shapetest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	# клетки формы: лестница не поворачивается в дырку, а все повороты остаются внутри габарита
	check(Catalog.cells_of("stairs", 0).size() == 3, "у лестницы три клетки")
	check(Catalog.cells_of("plank", 0) == [Rect2i(0, 0, 3, 1)], "у обычного блока одна клетка на весь размер")
	for t in Catalog.BLOCKS:
		for rot in 4:
			var s := Catalog.size_of(t, rot)
			var area := 0
			for c in Catalog.cells_of(t, rot):
				check(Rect2i(Vector2i.ZERO, s).encloses(c), "%s rot %d: клетка %s вне габарита %s" % [t, rot, c, s])
				area += c.size.x * c.size.y
			var base := 0
			for c in Catalog.cells_of(t, 0):
				base += c.size.x * c.size.y
			check(area == base, "%s rot %d: площадь формы сохраняется" % [t, rot])
	# лестница поднимается вправо: ступень внизу слева, верх справа; после поворота на 90° — другая сторона
	check(Catalog.cells_of("stairs", 1).size() == 3, "поворот лестницы считается")

	var g: Node2D = load("res://scripts/game.gd").new()
	add_child(g)
	await get_tree().process_frame
	g.on_phase(Catalog.Phase.PICK, {"round": 1, "offer": ["plank", "ice", "honey", "toxic"], "time": 15.0})
	var uid := 200
	for t in ["plank2", "plank4", "plank5", "plank6", "haybale", "barrel", "stairs", "girder", "stone_l", "stone_s", "stone_sq", "stone_cube", "spikyball", "spikes1", "spikes3", "ice2", "ice1"]:
		check(Catalog.BLOCKS.has(t), "%s есть в каталоге" % t)
		for rot in 4:
			uid += 1
			g._spawn_block(uid, 7, t, Vector2i(2, 4), rot)
			check(g.block_nodes.has(uid), "%s rot %d создан" % [t, rot])
			var n: Node = g.block_nodes[uid]
			if Catalog.BLOCKS[t].kind == "solid":
				var shapes := 0
				for ch in n.get_children():
					if ch is CollisionShape2D:
						shapes += 1
				check(shapes == Catalog.cells_of(t, rot).size(), "%s rot %d: коллайдеров %d" % [t, rot, shapes])
			g._clear_blocks()
	print("shapetest: ", "OK" if failures == 0 else "%d сбоев" % failures)
	get_tree().quit(1 if failures else 0)
