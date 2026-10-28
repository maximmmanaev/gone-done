extends Node
## Проверка Character (scripts/ported/characters/character.gd): бег, прыжок, стена, смерть, финиш, модификаторы.
##   godot --headless --path . tests/charactertest.tscn

var failures := 0
var c: Character


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _floor(rect: Rect2) -> void:
	var b := StaticBody2D.new()
	b.collision_layer = 1
	var s := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = rect.size
	s.shape = r
	b.position = rect.get_center()
	b.add_child(s)
	add_child(b)


func _spawn(pos: Vector2) -> void:
	if c:
		c.queue_free()
	c = Character.new()
	c.collision_layer = 2
	c.collision_mask = 1
	var s := CollisionShape2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(14, 28.8)
	s.shape = r
	c.add_child(s)
	add_child(c)
	c.position = pos
	c.spawn_position = pos
	c.active = true


func _frames(n: int, dir := 0.0, jump := false, sprint := false) -> void:
	for i in n:
		c.feed_input(dir, jump, sprint)
		await get_tree().physics_frame


func _ready() -> void:
	_floor(Rect2(0, 200, 1000, 40))       # пол, верх на y=200
	_floor(Rect2(300, 0, 20, 200))        # стена справа от x=300, до пола
	_spawn(Vector2(50, 180))
	await _frames(30)
	check(c.on_ground, "встал на пол")
	check(absf(c.position.y + 14.4 - 200.0) < 2.0, "ноги на полу (y=%.1f)" % c.position.y)

	# бег и спринт
	await _frames(40, 1.0)
	check(is_equal_approx(c.velocity.x, c.run_speed) and c.facing == 1, "бег вправо до run_speed (vx=%.1f)" % c.velocity.x)
	check(c.current_anim == Character.AnimState.RUN, "анимация RUN")
	_spawn(Vector2(50, 180))
	await _frames(40, 1.0, false, true)
	check(is_equal_approx(c.velocity.x, c.run_speed * c.sprint_multiplier), "спринт ×%.2f" % c.sprint_multiplier)
	await _frames(40)
	check(absf(c.velocity.x) < 0.1 and c.current_anim == Character.AnimState.IDLE, "трение остановило")

	# прыжок: высота, сигнал, приземление
	_spawn(Vector2(50, 180))
	await _frames(20)
	var jumped := [0]
	var landed := [0]
	c.jumped.connect(func(): jumped[0] += 1)
	c.landed.connect(func(_v): landed[0] += 1)
	var top := c.position.y
	for i in 60:
		c.feed_input(0.0, i < 40)
		await get_tree().physics_frame
		top = minf(top, c.position.y)
	var rise := 185.0 - top
	check(jumped[0] == 1, "сигнал jumped один раз (%d)" % jumped[0])
	check(rise > 30.0 and rise < 60.0, "высота прыжка в норме (%.1f px)" % rise)
	check(landed[0] == 1 and c.on_ground, "приземлился, landed=%d" % landed[0])

	# короткое нажатие прыгает ниже
	_spawn(Vector2(50, 180))
	await _frames(20)
	var top2 := c.position.y
	for i in 40:
		c.feed_input(0.0, i < 3)
		await get_tree().physics_frame
		top2 = minf(top2, c.position.y)
	check(185.0 - top2 < rise - 8.0, "короткий прыжок ниже полного (%.1f < %.1f)" % [185.0 - top2, rise])

	# койот-тайм: прыжок сразу после схода с края
	_spawn(Vector2(50, 180))
	await _frames(20)
	c.on_ground = false
	c.jump_grace_timer = c.jump_grace_time
	c.feed_input(0.0, true)
	c.step(1.0 / 60.0)
	check(c.velocity.y < -100.0, "койот-тайм позволяет прыгнуть")

	# прыжок от стены
	_spawn(Vector2(270, 100))
	var wj := false
	for i in 90:
		c.feed_input(1.0, i == 60)
		await get_tree().physics_frame
		if i > 60 and c.velocity.x < -50.0 and c.velocity.y < 0.0:
			wj = true
	check(wj, "прыжок от стены отбрасывает влево")

	# модификаторы: лёд — меньше трения; мёд — слабее прыжок
	_spawn(Vector2(50, 180))
	await _frames(20)
	c.apply_physics_modifier("ice", {"ground_friction": 0.1})
	await _frames(30, 1.0)
	await _frames(15)
	check(c.velocity.x > 20.0, "на льду скользит (vx=%.1f)" % c.velocity.x)
	c.remove_all_physics_modifers()
	check(is_equal_approx(c.ground_friction_modifier, 1.0), "модификаторы сброшены")

	# смерть: сигнал, неуязвимость, респавн
	_spawn(Vector2(50, 180))
	await _frames(20)
	var cause := [""]
	c.died.connect(func(x): cause[0] = x)
	c.start_invincible_timer(0.5)
	c.kill_character("spikes")
	check(not c.dying, "неуязвимость защищает")
	c.invincible_timer = 0.0
	c.kill_character("spikes")
	check(c.dying and cause[0] == "spikes", "смерть от шипов")
	await _frames(40)
	check(c.dead and c.current_anim == Character.AnimState.DIE, "умер (DIE)")
	c.feed_input(1.0, true)
	check(c._axis() == 0.0, "мёртвый не слушает ввод")
	c.respawn()
	check(not c.dead and c.position == c.spawn_position, "респавн")

	# финиш, самоубийство, пит
	_spawn(Vector2(50, 180))
	await _frames(10)
	var won := [false]
	c.succeeded.connect(func(): won[0] = true)
	c.set_success(true)
	c.kill_character("spikes")
	check(won[0] and c.success and not c.dying, "финишировавший не умирает")
	_spawn(Vector2(50, 180))
	await _frames(10)
	for i in 70:
		c.suicide = true
		await get_tree().physics_frame
	check(c.dying or c.dead, "самоубийство по удержанию")

	# пружина и пауза
	_spawn(Vector2(50, 180))
	await _frames(10)
	c.bounce(400.0, Vector2.UP)
	check(c.velocity.y == -400.0, "пружина вверх")
	c.pause()
	c.velocity = Vector2.ZERO
	c.unpause()
	check(c.velocity.y == -400.0, "пауза сохраняет скорость")

	# реестр
	check(Character.all_characters.has(c), "персонаж в all_characters")
	print("charactertest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
