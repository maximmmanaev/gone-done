# Каркас из structur/MovingPlatform.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name MovingPlatform
extends ActiveBlock

@export var move_speed: float = 40.0
@export var move_angle: float
@export var max_distance: float = 96.0
@export var fan: Node2D
@export var move_dir: Vector3
var amount_moved: float
@export var start_pos: Vector3
var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
var animator: AnimationPlayer
var rb: RigidBody2D

func _ready() -> void:  # C# Start
	start_origin = position
	last_position = position
	setup_zone(platform_size, Vector2(0, -platform_size.y))


func act(delta_time: float) -> void:  # C# Act
	var dir := Vector2.RIGHT.rotated(deg_to_rad(move_angle))
	amount_moved += move_speed * delta_time * _sign
	if amount_moved >= max_distance:
		amount_moved = max_distance
		_sign = -1.0
	elif amount_moved <= 0.0:
		amount_moved = 0.0
		_sign = 1.0
	var prev := position
	position = start_origin + dir * amount_moved
	last_velocity = velocity
	velocity = (position - prev) / delta_time
	last_position = position

var platform_size := Vector2(48, 8)
var start_origin := Vector2.ZERO
var _sign := 1.0


func _physics_process(delta: float) -> void:
	super(delta)
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.character_inherited_motion = velocity


func on_character_entered(_c: Character) -> void:
	pass


func on_character_exited(c: Character) -> void:
	c.character_inherited_motion = Vector2.ZERO
