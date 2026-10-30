extends Node
## Проверка блоков оригинала: CrumblingBlock (хрупкий), AutoDoor (автодверь), PunchingBlock (боксирующий).
##   godot --headless --path . tests/newblocktest.tscn

var failures := 0
var c: Character


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _floor() -> void:
	var b := StaticBody2D.new()
	b.collision_layer = 1
	var s := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(2000, 40)
	s.shape = r
	b.position = Vector2(500, 420)
	b.add_child(s)
	add_child(b)   # верх на y=400


func _char(pos: Vector2) -> Character:
	var ch := Character.new()
	ch.collision_layer = 2
	ch.collision_mask = 1
	var s := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(14, 28.8)
	s.shape = r
	ch.add_child(s)
	add_child(ch)
	ch.position = pos
	ch.spawn_position = pos
	ch.active = true
	return ch


func _solid(center: Vector2, size: Vector2) -> StaticBody2D:
	var b := StaticBody2D.new()
	b.collision_layer = 1
	b.position = center
	var s := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = size
	s.shape = r
	b.add_child(s)
	add_child(b)
	return b


func _frames(n: int) -> void:
	for i in n:
		await get_tree().physics_frame


func _ready() -> void:
	_floor()

	# --- CrumblingBlock: держит, пока на нём не постояли fall_delay, потом падает и теряет коллайдер
	var body := _solid(Vector2(100, 392), Vector2(48, 16))   # верх y=384
	var cb := CrumblingBlock.new()
	body.add_child(cb)
	cb.setup_body(body, Vector2(48, 16))
	cb.is_active = true
	c = _char(Vector2(100, 360))
	await _frames(20)
	check(absf(c.position.y - (384.0 - 14.4)) < 3.0, "стоит на хрупком блоке (y=%.1f)" % c.position.y)
	check(not cb.falling or cb.collide_time >= 0.0, "касание запустило отсчёт")
	await _frames(int(cb.fall_delay * 60.0) + 6)
	check(cb.falling, "после fall_delay блок падает")
	await _frames(60)
	check(body.position.y > 392.0 + 8.0, "блок опустился (y=%.1f)" % body.position.y)
	check(c.position.y > 384.0, "игрок провалился вместе с обрушением (y=%.1f)" % c.position.y)
	cb.reset_play_state()
	check(not cb.falling and is_equal_approx(body.position.y, 392.0) and body.visible, "reset возвращает блок")
	c.queue_free(); body.queue_free(); await _frames(2)

	# --- AutoDoor: открывается и закрывается по таймеру; закрывшись на игроке, убивает
	var door_body := _solid(Vector2(300, 376), Vector2(16, 48))   # 1x3, верх y=352
	var door := AutoDoor.new()
	door_body.add_child(door)
	door.setup_body(door_body, Vector2(16, 48))
	door.interval = 0.5
	door.is_active = true
	await _frames(10)
	check(not door.open, "дверь сначала закрыта")
	await _frames(int(door.interval * 60.0) + 4)
	check(door.open and door.collider.disabled, "через interval открылась, коллайдер выключен")
	c = _char(Vector2(300, 380))
	await _frames(int(door.interval * 60.0) + int(door.door_hazard_delay * 60.0) + 12)
	check(c.dead or c.dying, "закрывшаяся дверь убила стоявшего в проёме")
	door.reset_play_state()
	check(not door.open and not door.collider.disabled, "reset закрывает дверь")
	c.queue_free(); door_body.queue_free(); await _frames(2)

	# --- PunchingBlock: шаг на кнопку -> перчатка толкает того, кто стоит перед ней
	var pb_body := _solid(Vector2(600, 392), Vector2(32, 16))   # 2x1
	var pb := PunchingBlock.new()
	pb_body.add_child(pb)
	pb.dir = Vector2.RIGHT
	pb.setup_body(pb_body, Vector2(32, 16))
	pb.is_active = true
	var runner := _char(Vector2(600, 360))        # на кнопке
	c = _char(Vector2(640, 385))                  # перед перчаткой
	await _frames(40)
	check(c.position.x > 646.0, "перчатка толкнула соседа вправо (x=%.1f)" % c.position.x)
	check(not (c.dead or c.dying), "удар не убивает")
	runner.queue_free(); c.queue_free()

	print("newblocktest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
