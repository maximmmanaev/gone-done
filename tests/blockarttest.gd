extends Node
## Проверка оригинальной графики блоков: BlockArt.make / BlockArt.has.
##   godot --headless --path . tests/blockarttest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	var px := Vector2(28.8, 28.8)
	check(BlockArt.make("no_such_block", px) == null, "неизвестный блок -> null")
	check(BlockArt.make("plank", px) == null, "блок без спрайта (plank) -> null, рисует Art")
	for t in BlockArt.MAP:
		var n: Node2D = BlockArt.make(t, px)
		check(n != null, "%s: спрайт найден" % t)
		if n == null:
			continue
		var sp := n as AnimatedSprite2D
		check(sp != null and sp.sprite_frames.get_frame_count("default") >= 1, "%s: есть кадры" % t)
		if sp == null:
			continue
		var tex: Texture2D = sp.sprite_frames.get_frame_texture("default", 0)
		var sz := tex.get_size() * sp.scale
		check(sz.x <= px.x + 0.5 and sz.y <= px.y + 0.5, "%s: влезает в блок (%s в %s)" % [t, sz, px])
		check(sz.x >= px.x * 0.4 or sz.y >= px.y * 0.4, "%s: не крошечный (%s)" % [t, sz])
	var wide: Node2D = BlockArt.make("ice", Vector2(86.4, 28.8))
	check(wide != null and (wide as AnimatedSprite2D).sprite_frames.get_frame_texture("default", 0).get_size().x * wide.scale.x > 80.0, "ice 3x1 растянут по ширине")
	var game := load("res://scripts/game.gd").new() as Node2D
	add_child(game)
	game._spawn_block(1, 1, "crossbow", Vector2i(20, 3), 1)
	var launcher: ProjectileLauncher = game.ported.back()
	check(launcher.shot_sprite != null and not launcher.shot_sprite.is_playing(), "арбалет стоит на первом кадре до выстрела")
	launcher.shoot_projectile_0()
	check(launcher.shot_sprite != null and launcher.shot_sprite.is_playing()
		and not launcher.shot_sprite.sprite_frames.get_animation_loop("default"), "анимация арбалета запускается один раз при выстреле")
	check(launcher.shots[0].get_child(0) is AnimatedSprite2D, "летящая стрела использует спрайт Unity")
	launcher.reset_play_state()
	check(launcher.shot_sprite != null and not launcher.shot_sprite.is_playing()
		and launcher.shot_sprite.frame == 0, "новый забег сбрасывает анимацию арбалета")
	game.free()
	print("blockarttest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
