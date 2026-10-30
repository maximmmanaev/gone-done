extends Node
## Проверка блоков оригинала: HockeyShooter (хоккейный стрелок), AnimalCannon (пушка), Beehive (улей).
##   godot --headless --path . tests/newblock2test.tscn

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

	# --- HockeyShooter: шайба летит по направлению, отбрасывает персонажа, не убивает
	var hs := HockeyShooter.new()
	hs.position = Vector2(100, 384)
	hs.dir = Vector2.RIGHT
	hs.initial_delay = 0.2
	hs.interval = 5.0
	add_child(hs)
	hs.is_active = true
	c = _char(Vector2(180, 385))
	await _frames(90)
	check(c.velocity.x > 60.0 or c.position.x > 190.0, "шайба толкнула персонажа вправо (x=%.1f vx=%.1f)" % [c.position.x, c.velocity.x])
	check(not (c.dead or c.dying), "шайба не убивает")
	check(hs.pucks_fired >= 1, "выстрелила шайба")
	hs.reset_play_state()
	check(hs.pucks_fired == 0, "reset обнуляет выстрелы")
	c.queue_free(); hs.queue_free(); await _frames(2)

	# --- AnimalCannon: захватывает, держит time_to_launch, выстреливает по направлению и не хватает сразу снова
	var cn := AnimalCannon.new()
	cn.position = Vector2(300, 370)
	cn.dir = Vector2.RIGHT
	cn.time_to_launch = 0.3
	add_child(cn)
	cn.setup_zone(Vector2(32, 32))
	cn.is_active = true
	c = _char(Vector2(300, 372))
	await _frames(10)
	check(cn.chrs_in_cannon.has(c) and c.frozen, "персонаж в пушке заморожен")
	await _frames(int(cn.time_to_launch * 60.0) + 6)
	check(not c.frozen and c.velocity.x > 150.0, "выстрел: скорость вправо (vx=%.1f)" % c.velocity.x)
	check(not cn.chrs_in_cannon.has(c), "после выстрела пушка пуста")
	await _frames(30)
	check(c.position.x > 340.0, "персонаж улетел вперёд (x=%.1f)" % c.position.x)
	cn.reset_play_state()
	c.queue_free(); cn.queue_free(); await _frames(2)

	# --- Beehive: пчёлы вылетают через birth_time, догоняют и убивают; после reset возвращаются в улей
	var bh := Beehive.new()
	bh.position = Vector2(500, 380)
	bh.birth_time = 0.2
	add_child(bh)
	bh.is_active = true
	c = _char(Vector2(570, 385))
	c.active = false   # стоит на месте
	await _frames(20)
	check(bh.swarm.position.length() < 2.0 or bh.swarm.position.x > -1.0, "пока рано, пчёлы в улье")
	await _frames(150)
	check(c.dead or c.dying, "пчёлы догнали и убили (dead=%s dist=%.1f)" % [c.dead, bh.swarm.global_position.distance_to(c.global_position)])
	bh.reset_play_state()
	check(bh.swarm.position.length() < 0.5 and not bh.unleashed, "reset вернул пчёл в улей")

	print("newblock2test: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
