extends Node
## Проверка импорта оригинальных ассетов: manifest.json, спрайты, шрифты, тексты.
##   godot --headless --path . tests/assetstest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	var f := FileAccess.open("res://assets/manifest.json", FileAccess.READ)
	check(f != null, "manifest.json существует")
	if f == null:
		get_tree().quit(1)
		return
	var m: Dictionary = JSON.parse_string(f.get_as_text())
	var sprites: Dictionary = m.get("sprites", {})
	check(sprites.has("Chicken_Run") and sprites["Chicken_Run"].size() >= 6, "Chicken_Run >= 6 кадров")
	check(sprites.has("Chicken_Idle"), "Chicken_Idle есть")
	if sprites.has("Chicken_Idle"):
		var img := Image.load_from_file(ProjectSettings.globalize_path(sprites["Chicken_Idle"][0]))
		check(img != null and img.get_size() == Vector2i(95, 164), "Chicken_Idle.000 = 95x164")
	check(m.get("text", {}).has("ru"), "есть русский текст")
	check(m.get("fonts", []).size() == 9, "9 шрифтов")
	for p in sprites.get("Chicken_Run", []):
		check(not str(p).contains("_2.png"), "Chicken_Run: нет дубликатов _2")
	print("assetstest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
