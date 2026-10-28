class_name Player
extends Character
## Локальный игрок: физика и состояние живут в Character (scripts/ported/characters/character.gd),
## здесь — слой, который нужен игре: рисунок насекомого, слои столкновений и правила комнаты.

const SPEED := 115.0
const SIDE_BOUNCE_LIFT := 130.0      # боковая пружина ещё и подбрасывает

var body_color := Color.WHITE
var sprint_allowed := true   # правило комнаты «без бега»
var kind := 0
var insect: Node2D


func _ready() -> void:
	super()
	collision_layer = 2   # слой игроков
	collision_mask = 1    # сталкиваемся только с миром
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Catalog.PLAYER_SIZE
	shape.shape = rect
	add_child(shape)

	insect = Art.make_insect(kind, body_color)
	add_child(insect)
	_update_pupil()


func _physics_process(delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		return
	read_local_input()
	sprint = sprint and sprint_allowed
	step(delta)
	_update_pupil()


func _update_pupil() -> void:
	if insect:
		insect.scale = Vector2(float(facing), 1.0) * Catalog.INSECT_K
