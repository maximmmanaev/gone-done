## Скины оригинала: собирает SpriteFrames из спрайтов assets/manifest.json (группы вида `<Skin>_<Anim>`).
class_name SkinLibrary
extends RefCounted

const DEFAULT_SKIN := "Chicken"
const FPS := 12.0   # GUESS: тайминг анимаций в декомпилированном коде не сохранился
const REQUIRED := ["Idle", "Run", "JumpGoingUp"]

# анимация в игре -> [группа в манифесте, цикл?, запасные группы]
const ANIMS := {
	"idle": ["Idle", true, []],
	"run": ["Run", true, ["Walk", "Idle"]],
	"walk": ["Walk", true, ["Run", "Idle"]],
	"jump_up": ["JumpGoingUp", false, ["Idle"]],
	"jump_top": ["JumpTop", false, ["JumpGoingUp", "Idle"]],
	"jump_down": ["JumpGoingDown", false, ["JumpTop", "JumpGoingUp", "Idle"]],
	"land": ["Landing", false, ["LandingSoft", "Idle"]],
	"crouch": ["Crouch", true, ["TransCrouch", "Idle"]],
	"look_up": ["LookUp", true, ["TransLookUp", "Idle"]],
	"wall_slide": ["WallSlide", true, ["JumpGoingDown", "Idle"]],
	"dead": ["DeadFalling", true, ["Dead_MidAir", "DeathShock", "JumpGoingDown", "Idle"]],
	"victory": ["Victory", true, ["Idle"]],
}

static var _skins: PackedStringArray = PackedStringArray()
static var _groups: Dictionary = {}
static var _cache: Dictionary = {}


static func _load() -> void:
	if not _groups.is_empty():
		return
	var f := FileAccess.open("res://assets/manifest.json", FileAccess.READ)
	if f == null:
		return
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	if not (parsed is Dictionary):
		return
	var sprites: Dictionary = parsed.get("sprites", {})
	var anim_names := {}
	for g in sprites:
		if str(g).begins_with(DEFAULT_SKIN + "_"):
			anim_names[str(g).substr(DEFAULT_SKIN.length() + 1)] = true
	var by_skin := {}
	for g in sprites:
		var s := str(g)
		for i in s.length():
			if s[i] == "_" and anim_names.has(s.substr(i + 1)):
				var skin := s.substr(0, i)
				if not by_skin.has(skin):
					by_skin[skin] = {}
				by_skin[skin][s.substr(i + 1)] = sprites[g]
	var names: Array = []
	for skin in by_skin:
		var ok := true
		for r in REQUIRED:
			ok = ok and by_skin[skin].has(r)
		if ok:
			names.append(skin)
	names.sort_custom(func(a, b): return a == DEFAULT_SKIN or (b != DEFAULT_SKIN and a < b))
	_groups = by_skin
	_skins = PackedStringArray(names)


static func skins() -> PackedStringArray:
	_load()
	return _skins


static func has_skin(skin: String) -> bool:
	return skin in skins()


static func frames(skin: String) -> SpriteFrames:
	_load()
	if not has_skin(skin):
		skin = DEFAULT_SKIN
	if _cache.has(skin):
		return _cache[skin]
	var sf := SpriteFrames.new()
	sf.remove_animation("default")
	var groups: Dictionary = _groups.get(skin, {})
	for anim in ANIMS:
		var spec: Array = ANIMS[anim]
		var chain: Array = [spec[0]] + spec[2]
		var paths: Array = []
		for g in chain:
			if groups.has(g):
				paths = groups[g]
				break
		sf.add_animation(anim)
		sf.set_animation_speed(anim, FPS)
		sf.set_animation_loop(anim, spec[1])
		for p in paths:
			var tex: Texture2D = load(p) if ResourceLoader.exists(p) else null
			if tex != null:
				sf.add_frame(anim, tex)
	_cache[skin] = sf
	return sf


## Сетевой/сохранённый индекс скина (0..6) -> имя скина оригинала.
static func skin_for_kind(kind: int) -> String:
	var all := skins()
	if all.is_empty():
		return DEFAULT_SKIN
	return all[posmod(kind, all.size())]


## Спрайт скина в масштабе игры (для предпросмотра и чужих игроков).
static func make_sprite(skin: String, scale_k: float) -> AnimatedSprite2D:
	var sp := AnimatedSprite2D.new()
	sp.sprite_frames = frames(skin)
	sp.scale = Vector2.ONE * scale_k
	sp.play("idle")
	return sp
