extends Node
## Автозагрузка `Audio`: звуки по событиям Wwise и игровым подсказкам, отдельный канал музыки.
## Неизвестное имя молча игнорируется.

const EVENTS_PATH := "res://assets/audio/events.json"
const CUES_PATH := "res://assets/audio_cues.json"
const POOL_SIZE := 16
const MUSIC_VOLUME_DB := -14.0   # GUESS: громкость фоновой музыки относительно эффектов

var _events: Dictionary = {}
var _cache: Dictionary = {}
var _pool: Array[AudioStreamPlayer] = []
var _next := 0
var _music_cues: Dictionary = {}
var _music: AudioStreamPlayer
var _music_cue := ""


func _ready() -> void:
	_events = _read_dict(EVENTS_PATH)
	var cues := _read_dict(CUES_PATH)
	_events.merge(cues.get("effects", {}))
	_music_cues = cues.get("music", {})
	_music = AudioStreamPlayer.new()
	_music.volume_db = MUSIC_VOLUME_DB
	add_child(_music)
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)



func _read_dict(path: String) -> Dictionary:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	return parsed if parsed is Dictionary else {}


## Музыка играет отдельно от эффектов и продолжается между раундами.
func play_music(cue: String) -> void:
	if cue == _music_cue or not _music_cues.has(cue):
		return
	var config: Dictionary = _music_cues[cue]
	var original := _stream_for_id(int(config.source)) as AudioStreamOggVorbis
	if original == null:
		return
	var stream := original.duplicate() as AudioStreamOggVorbis
	stream.loop = bool(config.loop)
	_music.stream = stream
	_music_cue = cue
	_music.play()


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
	# Начинаем со случайного варианта и ищем следующий, если файла нет в сборке.
	var first := randi_range(0, ids.size() - 1)
	for offset in ids.size():
		var stream := _stream_for_id(int(ids[(first + offset) % ids.size()]))
		if stream == null:
			continue
		var p := _pool[_next]
		_next = (_next + 1) % POOL_SIZE
		p.stream = stream
		p.play()
		return



func _stream_for_id(id: int) -> AudioStream:
	var path := "res://assets/audio/%d.ogg" % id
	if not _cache.has(path):
		_cache[path] = _load_stream(path)
	return _cache[path]


func _load_stream(path: String) -> AudioStream:
	if not ResourceLoader.exists(path):
		return null
	# Старые выгрузки могли оставлять пустые OGG. В экспортированном паке
	# исходного файла может не быть: ResourceLoader читает импортированную копию.
	var source := FileAccess.open(path, FileAccess.READ)
	if source != null and source.get_length() == 0:
		return null
	return load(path)
