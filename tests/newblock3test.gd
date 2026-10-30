extends Node
## Проверка блоков оригинала: PressureTriggerSpikes, FireHydrant, FlippingBlock, RotateBlock, DumbWaiter, PunchingPlant.
##   godot --headless --path . tests/newblock3test.tscn

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

	# --- PressureTriggerSpikes: наступил на плиту -> через trigger_delay шипы убивают стоящего; lock_out_time не даёт сработать снова
	var ps := PressureTriggerSpikes.new()
	ps.position = Vector2(100, 392)
	add_child(ps)
	ps.setup_zone(Vector2(30, 14), Vector2(0, -4))
	ps.is_active = true
	c = _char(Vector2(100, 385))
	await _frames(int(ps.trigger_delay * 60.0) + 20)
	check(c.dead or c.dying, "шипы плиты убили стоящего")
	check(is_equal_approx(ps.lock_out_time, 1.0), "lock_out_time = 1.0 (из C#)")
	ps.reset_play_state()
	check(not ps.triggered, "reset сбрасывает плиту")
	c.queue_free(); ps.queue_free(); await _frames(2)

	# --- FireHydrant: гейзер поднимает вверх
	var fh := FireHydrant.new()
	fh.position = Vector2(200, 384)
	fh.interval = 0.2
	fh.rise_time = 0.1
	fh.fall_time = 0.1
	fh.on_time = 2.0
	add_child(fh)
	fh.setup_geyser(Vector2(16, 16))
	fh.is_active = true
	c = _char(Vector2(200, 385))
	var y0 := c.position.y
	await _frames(40)
	check(c.position.y < y0 - 25.0, "гейзер поднял персонажа (y %.1f -> %.1f)" % [y0, c.position.y])
	fh.reset_play_state()
	check(not fh.on, "reset выключает гейзер")
	c.queue_free(); fh.queue_free(); await _frames(2)

	# --- FlippingBlock: после interval переворачивается шипами вверх и убивает стоящего
	var fb_body := _solid(Vector2(300, 392), Vector2(32, 16))
	var fb := FlippingBlock.new()
	fb_body.add_child(fb)
	fb.interval = 0.3
	fb.setup_body(fb_body, Vector2(32, 16))
	fb.is_active = true
	c = _char(Vector2(300, 360))
	await _frames(12)
	check(fb.solid and not (c.dead or c.dying), "сначала безопасная сторона")
	await _frames(int(fb.interval * 60.0) - 12 + 8)
	check(not fb.solid and (c.dead or c.dying), "перевернулся шипами вверх и убил")
	fb.reset_play_state()
	check(fb.solid, "reset возвращает безопасную сторону")
	c.queue_free(); fb_body.queue_free(); await _frames(2)

	# --- RotateBlock: каждые interval поворачивается на degrees
	var rb_body := AnimatableBody2D.new()
	rb_body.position = Vector2(400, 300)
	add_child(rb_body)
	var rb := RotateBlock.new()
	rb_body.add_child(rb)
	rb.interval = 0.3
	rb.degrees = 90.0
	rb.rotate_speed = 360.0
	rb.setup_body(rb_body)
	rb.is_active = true
	await _frames(40)
	check(absf(rb_body.rotation_degrees - 90.0) < 3.0, "повернулся на 90 по часовой (%.1f)" % rb_body.rotation_degrees)
	rb.reset_play_state()
	await _frames(3)
	check(absf(rb_body.rotation) < 0.01, "reset возвращает угол 0")
	rb_body.queue_free(); await _frames(2)

	# --- DumbWaiter: платформа едет вверх, когда на неё встали
	var dw_body := AnimatableBody2D.new()
	dw_body.sync_to_physics = true
	dw_body.collision_layer = 1
	dw_body.position = Vector2(500, 392)
	var dws := CollisionShape2D.new()
	var dwr := RectangleShape2D.new()
	dwr.size = Vector2(32, 16)
	dws.shape = dwr
	dw_body.add_child(dws)
	add_child(dw_body)
	var dw := DumbWaiter.new()
	dw_body.add_child(dw)
	dw.net_movement_delay = 0.5
	dw.move_distance = 60.0
	dw.move_speed = 120.0
	dw.setup_body(dw_body, Vector2(32, 16))
	dw.is_active = true
	c = _char(Vector2(500, 360))
	await _frames(15)
	check(not dw.movement_activated or dw_body.position.y > 391.0, "стоит, пока не прошла задержка")
	await _frames(70)
	check(dw_body.position.y < 392.0 - 30.0, "платформа поднялась (y=%.1f)" % dw_body.position.y)
	check(c.position.y < 392.0 - 30.0 - 8.0, "персонаж едет вместе (y=%.1f)" % c.position.y)
	dw.is_active = false   # как в game.gd: в конце забега блок выключают и сбрасывают
	dw.reset_play_state()
	await _frames(3)
	check(absf(dw_body.position.y - 392.0) < 0.5 and not dw.movement_activated, "reset возвращает платформу")
	c.queue_free(); dw_body.queue_free(); await _frames(2)

	# --- PunchingPlant: заметила персонажа впереди -> отбрасывает, не убивает
	var pp := PunchingPlant.new()
	pp.position = Vector2(600, 384)
	pp.dir = Vector2.RIGHT
	pp.fear_time = 0.1
	add_child(pp)
	pp.setup_zone(Vector2(48, 24), Vector2(32, 0))
	pp.is_active = true
	c = _char(Vector2(630, 385))
	await _frames(40)
	check(c.position.x > 645.0, "растение отбросило вправо (x=%.1f)" % c.position.x)
	check(not (c.dead or c.dying), "удар не убивает")

	print("newblock3test: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
