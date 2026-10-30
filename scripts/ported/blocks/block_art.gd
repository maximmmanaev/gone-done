## Оригинальные спрайты блоков: тип блока из catalog.gd -> группа спрайтов в assets/manifest.json.
## Нет спрайта (или нет манифеста) -> make() возвращает null, и вызывающий рисует блок через Art.
class_name BlockArt
extends RefCounted

const FPS := 12.0   # GUESS
# тип -> [группа, растягивать по размеру блока (иначе вписать с сохранением пропорций)]
const MAP := {
	"spring": ["SpringBoard", false],
	"coin": ["GoldCoin", false],
	"saw": ["SpinSaw", false],
	"dynamite": ["bomb", false],
	"bomb": ["NewBombs-miniBomb", false],
	"nuke": ["NewBombs-megaBomb", false],
	"boulder": ["Boulder", false],
	"box": ["Box-CardboardBox", false],
	"spikes": ["spike_1", false],
	"teleporter": ["Teleporter-Tele_On", false],
	"treadmill": ["TreadMill", true],
	"blackhole": ["blackhole-MainSwhirl", false],
	"ice": ["_static-Ice", true],
	"honey": ["_static-Honey", true],
	"toxic": ["Toxic_Water_Pool", true],
	"autodoor": ["Autodoor", false],
	"punchglove": ["BoxingGlove-BoxingGlove", false],
	"hockeypuck": ["HockeyShooter-HockeyPuck", false],
	"beehive": ["Beehive-Beehive", false],
	"cannon": ["Cannon-CannonWheel", false],
}

static var _sprites: Dictionary = {}
static var _loaded := false


static func _load() -> void:
	if _loaded:
		return
	_loaded = true
	var f := FileAccess.open("res://assets/manifest.json", FileAccess.READ)
	if f == null:
		return
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if parsed is Dictionary:
		_sprites = parsed.get("sprites", {})


static func has(type: String) -> bool:
	_load()
	return MAP.has(type) and _sprites.has(MAP[type][0])


static func make(type: String, px: Vector2) -> Node2D:
	if not has(type):
		return null
	var spec: Array = MAP[type]
	var sf := SpriteFrames.new()
	sf.set_animation_speed("default", FPS)
	var first := Vector2.ZERO   # масштаб считаем по первому кадру: размеры кадров в группе бывают разные
	for p in _sprites[spec[0]]:
		if not ResourceLoader.exists(p):
			continue
		var tex: Texture2D = load(p)
		sf.add_frame("default", tex)
		if first == Vector2.ZERO:
			first = tex.get_size()
	if sf.get_frame_count("default") == 0:
		return null
	var sp := AnimatedSprite2D.new()
	sp.sprite_frames = sf
	if spec[1]:
		sp.scale = px / first
	else:
		sp.scale = Vector2.ONE * minf(px.x / first.x, px.y / first.y)
	sp.play("default")
	return sp
