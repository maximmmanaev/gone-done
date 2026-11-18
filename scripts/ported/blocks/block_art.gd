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
	"dynamite": ["NewBombs-miniBomb", false],
	"bomb": ["bomb", false],
	"nuke": ["NewBombs-megaBomb", false],
	"boulder": ["Boulder", false],
	"box": ["Box-CardboardBox", false],
	"spikes": ["barbwire_2_", true],
	"crossbow": ["AS2-ArrowShooter", false],
	"crossbow_arrow": ["AS2-Arrow", false],
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
	"pressure": ["PressureTrigger-Curtain", true],
	"hydrant": ["FireHydrant", false],
	"plant": ["Flower-FlowerPunch", false],
	"cannon": ["Cannon-CannonWheel", false],
	"mover": ["HoriMove-Crates", true],
	"haybale": ["_static-Haybale", false],
	"barrel": ["_static-Barrel", false],
	"stairs": ["_static-Stairs", true],
	"spikyball": ["_static-SpikyBall", false],
	"spikes1": ["barbwire_1_", true],
	"spikes3": ["barbwire_3_", true],
	"ice2": ["_static-Ice", true],
	"ice1": ["_static-Ice", true],
	"flipper": ["Flipping-FlippingBlock", false],
	"rotator": ["_static-RotatingTire", false],
	"upblower": ["UpBlower-BlowerFan", false],
	"crate": ["_static-StaticBlocks", false],
	"girder": ["_static-LBoard", true],
	"lift": ["DumbWaiter", true],
	"stopwatch": ["Stopwatch-Anim_0", false],
	"jetpack": ["Jetpack", false],
	"jetpack_dispenser": ["Jetpack_Tower-Jetpack_Tower", false],
	"pendulum": ["WreckingBall-Body", false],
	"wrecking_chain": ["WreckingBall-ChainandBall", true],
	"swing_saw": ["SpinSaw", false],
	"flamethrower": ["FlameThrower-NewFlameThrowerBody", false],
	"tennis": ["_static-TennisBallShooter", false],
	"tennis_ball": ["GlowingTennisBall", false],
	"paper_plane": ["PaperAirplaneShooter-Mainbody", false],
	"paper_plane_shot": ["Airplane-AirplanePapermoving", false],
	"hover_platform": ["HoverFan", false],
	"one_way_gate": ["OneWayDoor-OneWayGate", true],
	"smooth_gear": ["SmoothRotate-SmoothRotate-GearSmoothRotate", false],
	"mover_diagonal": ["HoriMove-CratesSingle", true],
	"mover_short": ["HoriMove-Crates2", true],
	"ferris_pad": ["Ferris-Platform", true],
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


static func make(type: String, px: Vector2, autoplay := true) -> Node2D:
	if not has(type):
		return null
	var spec: Array = MAP[type]
	var sf := SpriteFrames.new()
	sf.set_animation_speed("default", FPS)
	sf.set_animation_loop("default", autoplay)
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
	if autoplay:
		sp.play("default")
	return sp
