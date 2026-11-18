extends Node
## Проверка звука: события извлечены, Audio не падает на неизвестном имени.
##   godot --headless --path . tests/audiotest.tscn

var failures := 0


func check(cond: bool, what: String) -> void:
	if not cond:
		failures += 1
		print("FAIL: ", what)


func _ready() -> void:
	var a: Node = get_node("/root/Audio")
	check(a.event_count() >= 100, "в events.json >= 100 событий (сейчас %d)" % a.event_count())
	a.play("no_such_event")
	var ogg := 0
	for f in DirAccess.get_files_at("res://assets/audio"):
		if f.ends_with(".ogg"):
			var source := FileAccess.open("res://assets/audio/" + f, FileAccess.READ)
			if source != null and source.get_length() > 0:
				ogg += 1
	check(ogg >= 100, "в assets/audio >= 100 непустых OGG (сейчас %d)" % ogg)
	var next: int = a._next
	a.play("SFX_Chicken_Jump")
	check(a._next != next, "SFX_Chicken_Jump загружает и проигрывает импортированный OGG")
	print("audiotest: ", "OK" if failures == 0 else "%d FAIL" % failures)
	get_tree().quit(1 if failures else 0)
