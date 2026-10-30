extends Node
## Проверка скинов оригинала: SkinLibrary, SpriteFrames и анимации Character.
##   godot --headless --path . tests/skintest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	var skins := SkinLibrary.skins()
	check(skins.size() >= 7, "скинов >= 7 (сейчас %d)" % skins.size())
	check("Chicken" in skins and skins[0] == "Chicken", "Chicken первый")
	var fr := SkinLibrary.frames("Chicken")
	check(fr.get_frame_count("run") >= 6, "run >= 6 кадров")
	for a in ["idle", "run", "walk", "jump_up", "jump_down", "jump_top", "land", "crouch", "wall_slide", "dead", "victory", "look_up"]:
		check(fr.has_animation(a) and fr.get_frame_count(a) >= 1, "анимация %s есть" % a)
	# скин без части анимаций (Hippo не имеет WallSlide/Dead) получает замены, а не дыры
	var h := SkinLibrary.frames("Hippo")
	check(h.has_animation("wall_slide") and h.get_frame_count("wall_slide") >= 1, "Hippo: wall_slide заменён")
	check(h.has_animation("dead") and h.get_frame_count("dead") >= 1, "Hippo: dead заменён")

	var floor_body := StaticBody2D.new()
	floor_body.collision_layer = 1
	var fs := CollisionShape2D.new()
	var fr2 := RectangleShape2D.new()
	fr2.size = Vector2(2000, 20)
	fs.shape = fr2
	floor_body.position = Vector2(0, 110)
	floor_body.add_child(fs)
	add_child(floor_body)

	var c := Character.new()
	c.collision_layer = 2
	c.collision_mask = 1
	var cs := CollisionShape2D.new()
	var cr := RectangleShape2D.new()
	cr.size = Vector2(14, 28.8)
	cs.shape = cr
	c.add_child(cs)
	add_child(c)
	c.position = Vector2(0, 80)
	c.spawn_position = c.position
	c.set_skin("no_such")
	check(c.skin_name == "Chicken", "неизвестный скин -> Chicken")
	c.set_skin("Panda")
	check(c.skin_name == "Panda", "set_skin(Panda)")
	c.active = true
	for i in 30:
		await get_tree().physics_frame
	check(c.sprite != null and c.sprite.animation == "idle", "стоя играет idle (сейчас %s)" % (c.sprite.animation if c.sprite else "null"))
	c.feed_input(1.0, false)
	for i in 20:
		c.feed_input(1.0, false)
		await get_tree().physics_frame
	check(c.sprite.animation in ["run", "walk"], "бег -> run/walk (сейчас %s)" % c.sprite.animation)
	c.feed_input(0.0, true)
	await get_tree().physics_frame
	await get_tree().physics_frame
	check(c.sprite.animation.begins_with("jump"), "прыжок -> jump_* (сейчас %s)" % c.sprite.animation)
	print("skintest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
