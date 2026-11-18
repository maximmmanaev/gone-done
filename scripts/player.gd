class_name Player
extends Character
## Локальный игрок: физика и состояние живут в Character (scripts/ported/characters/character.gd),
## здесь — слой, который нужен игре: рисунок насекомого, слои столкновений и правила комнаты.

const SPEED := 115.0
const SIDE_BOUNCE_LIFT := 130.0      # боковая пружина ещё и подбрасывает

var body_color := Color.WHITE
var sprint_allowed := true   # правило комнаты «без бега»
var sprint_on := false       # бег переключается нажатием: нажали — включился, нажали ещё раз — выключился
var kind := 0
var insect: Node2D   # запасной рисунок, если спрайтов оригинала нет


func _ready() -> void:
	super()
	collision_layer = 2   # слой игроков
	collision_mask = 1    # сталкиваемся только с миром
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Catalog.PLAYER_SIZE
	shape.shape = rect
	add_child(shape)

	var original_skin := SkinLibrary.skin_for_kind(kind)
	if not SkinLibrary.has_skin(original_skin):
		insect = Art.make_insect(kind, body_color)
		insect.scale = Vector2.ONE * Catalog.INSECT_K
		add_child(insect)
	else:
		set_skin(original_skin)
	jumped.connect(_play_movement_sound.bind("Jump"))
	landed.connect(func(_fall_speed: float): _play_movement_sound("Land"))


func _play_movement_sound(action: String) -> void:
	if not active or is_ghost or dying or dead or sprite == null:
		return
	var event := "SFX_%s_%s" % [skin_name, action]
	if not Audio.has(event):
		# Костюмы используют голос базового персонажа: Arara_Chicken → Chicken.
		var animal := skin_name.get_slice("_", skin_name.get_slice_count("_") - 1)
		event = "SFX_%s_%s" % [animal, action]
	Audio.play(event, global_position)


func _physics_process(delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		sprint_on = false
		return
	read_local_input()
	if Input.is_action_just_pressed("sprint"):
		sprint_on = not sprint_on
	sprint = sprint_on and sprint_allowed
	step(delta)
	if insect:
		insect.scale = Vector2(float(facing), 1.0) * Catalog.INSECT_K
