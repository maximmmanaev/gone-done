## Шайба хоккейного стрелка: летит по прямой, отбрасывает персонажа (не убивает), исчезает о стену или по таймеру.
class_name HockeyPuck
extends Area2D

var direction := Vector2.RIGHT
var speed := 220.0               # GUESS
var push_character_strength := 300.0   # C# pushCharacterStrength (значение GUESS)
var vertical_push_extra := 90.0        # C# VerticalPushExtra (значение GUESS)
var lifespan := 4.0              # GUESS
var _age := 0.0
var _done := false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1 | 2   # мир и игроки
	monitorable = false
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 4.0
	shape.shape = circle
	add_child(shape)
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_age += delta
	if _age >= lifespan:
		queue_free()


func _on_body_entered(body: Node) -> void:
	if _done:
		return
	if body is Character:
		if body.dead or body.dying or body.is_ghost:
			return
		body.add_impulse(direction * push_character_strength + Vector2(0, -vertical_push_extra))
	_done = true
	queue_free()
