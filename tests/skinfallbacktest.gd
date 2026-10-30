extends Node
## Нет ассетов оригинала (чистый клон без tools/import_assets.py): скины не «живут» только в манифесте,
## игрок рисуется запасным насекомым из art.gd.
##   godot --headless --path . tests/skinfallbacktest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	SkinLibrary.exists_fn = func(_p): return false
	SkinLibrary.reset()
	check(SkinLibrary.skins().is_empty(), "без файлов спрайтов скинов нет")
	var p := Player.new()
	p.kind = 2
	add_child(p)
	check(p.sprite == null and p.insect != null, "Player без ассетов рисует запасное насекомое")
	SkinLibrary.exists_fn = func(path): return ResourceLoader.exists(path)
	SkinLibrary.reset()
	check(SkinLibrary.skins().size() >= 7, "с ассетами скины возвращаются (%d)" % SkinLibrary.skins().size())
	print("skinfallbacktest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
