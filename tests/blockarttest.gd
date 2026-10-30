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
	print("blockarttest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
