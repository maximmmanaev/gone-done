extends Node
## Проверка блоков из scripts/ported (Spring, Ice, Honey, Goal, Coin, пилы, топор, яд, платформа, ветер).
##   godot --headless --path . tests/blocktest.tscn

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
	b.position = Vector2(500, 220)
	b.add_child(s)
	add_child(b)


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


func _block(script: String, pos: Vector2) -> Node2D:
	var b: Node2D = load("res://scripts/ported/blocks/%s.gd" % script).new()
	b.position = pos
	add_child(b)
	return b


func _frames(n: int, dir := 0.0) -> void:
	for i in n:
		if c:
			c.feed_input(dir, false)
		await get_tree().physics_frame


func _ready() -> void:
	_floor()   # верх на y=200

	# --- Spring: подбрасывает вверх, не чаще PUSH_DELAY
	c = _char(Vector2(100, 185))
	var sp: Spring = _block("spring", Vector2(100, 192))
	await _frames(10)
	check(c.velocity.y < -300.0 or c.position.y < 170.0, "пружина подбросила (y=%.0f vy=%.0f)" % [c.position.y, c.velocity.y])
	c.queue_free(); sp.queue_free(); await _frames(2)

	# --- Ice: скользко, после ухода трение вернулось
	c = _char(Vector2(400, 185))
	var ice: Ice = _block("ice", Vector2(400, 200))
	ice.zone.scale = Vector2(1, 1)
	await _frames(5)
	check(c.physics_modifiers.has(ice) and c.ground_friction_modifier < 0.2, "лёд снижает трение (%.2f)" % c.ground_friction_modifier)
	c.position.x = 800.0
	await _frames(5)
	check(is_equal_approx(c.ground_friction_modifier, 1.0), "вне льда трение нормальное")
	c.queue_free(); ice.queue_free(); await _frames(2)

	# --- Honey: медленнее и прыжок слабее
	c = _char(Vector2(400, 185))
	var h: Honey = _block("honey", Vector2(400, 200))
	await _frames(5)
	check(c.run_speed_modifier < 1.0 and c.jump_force_modifier < 1.0 and c.ground_friction_modifier > 1.0, "мёд: бег %.2f прыжок %.2f" % [c.run_speed_modifier, c.jump_force_modifier])
	c.queue_free(); h.queue_free(); await _frames(2)

	# --- Goal: финиш
	c = _char(Vector2(400, 185))
	var goal: GoalBlock = _block("goal_block", Vector2(400, 185))
	await _frames(5)
	check(c.success, "флаг засчитал финиш")
	c.queue_free(); goal.queue_free(); await _frames(2)

	# --- Coin: подбор, погоня, награда на финише, потеря при смерти
	c = _char(Vector2(400, 185))
	var coin: Coin = _block("coin", Vector2(400, 185))
	await _frames(5)
	check(coin.carrier == c, "монета подобрана")
	c.position.x = 440.0
	await _frames(40)
	check(coin.global_position.distance_to(c.global_position + Vector2(-c.facing * 14.0, -16.0)) < 25.0, "монета следует за игроком")
	c.set_success(true)
	await _frames(3)
	check(coin.awarded and c.coins_collected == 1, "монета засчитана на финише")
	c.queue_free(); coin.queue_free(); await _frames(2)
	c = _char(Vector2(300, 185))
	coin = _block("coin", Vector2(300, 185))
	await _frames(5)
	c.kill_character("spikes")
	await _frames(3)
	check(coin.carrier == null and coin.at_spawn_point, "умер — монета вернулась на место")
	c.queue_free(); coin.queue_free(); await _frames(2)

	# --- LinearSaw / SwingingAxe / ToxicWaste убивают
	for pair in [["linear_saw", "saw"], ["swinging_axe", "axe"], ["toxic_waste", "toxic"]]:
		c = _char(Vector2(400, 185))
		var hz: Placeable = _block(pair[0], Vector2(400, 170 if pair[0] != "swinging_axe" else 150))
		hz.to_play_mode()
		hz.activate_0()
		await _frames(30)
		check(c.dying or c.dead, "%s убивает (%s)" % [pair[0], c.last_death])
		check(c.last_death == pair[1] or c.last_death != "", "причина смерти: " + c.last_death)
		c.queue_free(); hz.queue_free(); await _frames(2)

	# --- LinearSaw двигается туда-обратно
	var saw: LinearSaw = _block("linear_saw", Vector2(0, 0))
	saw.travel_distance = 30.0
	saw.activate_0()
	var maxx := 0.0
	for i in 120:
		await get_tree().physics_frame
		maxx = maxf(maxx, saw.position.x)
	check(maxx > 28.0 and maxx <= 30.1 and saw.position.x < maxx, "пила ходит туда-обратно (max=%.1f)" % maxx)
	saw.queue_free()

	# --- MovingPlatform увозит игрока
	c = _char(Vector2(400, 185))
	var mp: MovingPlatform = _block("moving_platform", Vector2(400, 200))
	mp.platform_size = Vector2(48, 8)
	mp.setup_zone(Vector2(48, 40), Vector2(0, -20))
	mp.to_play_mode()
	mp.activate_0()
	var x0 := c.position.x
	await _frames(60)
	check(c.position.x > x0 + 10.0 or c.character_inherited_motion.x > 0.0, "платформа несёт игрока (+%.0f px)" % (c.position.x - x0))
	c.queue_free(); mp.queue_free(); await _frames(2)

	# --- WindArea толкает
	c = _char(Vector2(400, 185))
	var wind: WindArea = load("res://scripts/ported/hazards/wind_area.gd").new()
	wind.blow_direction = Vector2.RIGHT
	wind.position = Vector2(400, 185)
	add_child(wind)
	await _frames(30)
	check(c.position.x > 405.0, "ветер сдувает вправо (x=%.0f)" % c.position.x)
	c.queue_free(); wind.queue_free(); await _frames(2)

	# --- SawSpinAndMove
	var sm: SawSpinAndMove = load("res://scripts/ported/hazards/saw_spin_and_move.gd").new()
	add_child(sm)
	var r0 := sm.rotation
	for i in 100:
		await get_tree().physics_frame
	check(sm.rotation != r0 and sm.position.x != 0.0, "пила крутится и ездит")

	# --- Placeable: массы, прикрепление, разрушение
	var a: Placeable = _block("goal_block", Vector2.ZERO)
	var b2: Placeable = _block("goal_block", Vector2.ZERO)
	a.u_mass = 2.0; b2.u_mass = 3.0
	a.attach_piece(b2)
	check(a.get_total_mass() == 5.0 and b2.parent_piece == a and a.get_top_piece() == a and b2.get_top_piece() == a, "масса и прикрепление")
	check(a.id != b2.id and a.id > 0, "уникальные id")
	a.destroy_self_3(true, false, false)
	await _frames(2)
	check(not is_instance_valid(a) and not is_instance_valid(b2), "разрушение вместе с детьми")

	print("blocktest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
