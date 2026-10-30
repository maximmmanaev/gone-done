extends Node
## Автозагрузка `Audio`: проигрывает звуки оригинала по имени события из assets/audio/events.json.
## Неизвестное имя молча игнорируется.

const EVENTS_PATH := "res://assets/audio/events.json"
const POOL_SIZE := 16

var _events: Dictionary = {}
var _cache: Dictionary = {}
var _pool: Array[AudioStreamPlayer] = []
var _next := 0


func _ready() -> void:
	var f := FileAccess.open(EVENTS_PATH, FileAccess.READ)
	if f != null:
		var parsed: Variant = JSON.parse_string(f.get_as_text())
		if parsed is Dictionary:
			_events = parsed
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)


func has(event: String) -> bool:
	return _events.has(event)


func event_count() -> int:
	return _events.size()


func play(event: String, _pos := Vector2.ZERO) -> void:
	if not _events.has(event):
		return
	var ids: Array = _events[event]
	if ids.is_empty():
		return
	var path := "res://assets/audio/%d.ogg" % int(ids[randi() % ids.size()])
	if not _cache.has(path):
		_cache[path] = load(path) if ResourceLoader.exists(path) else null
	var stream: AudioStream = _cache[path]
	if stream == null:
		return
	var p := _pool[_next]
	_next = (_next + 1) % POOL_SIZE
	p.stream = stream
	p.play()
