# Каркас из structur/HorizontalMovingPlatform.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name HorizontalMovingPlatform
extends ActiveBlock

@export var move_speed: float = 40.0
@export var move_angle: float
@export var max_distance: float = 96.0
@export var move_dir: Vector3
var amount_moved: float
@export var start_pos: Vector3
var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
var animator: AnimationPlayer
@export var line_holder: Node2D
var line_position: Vector3
var rb: RigidBody2D

func _ready() -> void:  # C# Start
	var t := move_target if move_target else self
	start_origin = t.position - Vector2.RIGHT.rotated(deg_to_rad(0.0)) * initial_moved
	amount_moved = initial_moved
	last_position = t.position
	if move_target == null:
		setup_zone(platform_size, Vector2(0, -platform_size.y))


func act(delta_time: float) -> void:  # C# Act
	var t := move_target if move_target else self
	var dir := Vector2.RIGHT.rotated(deg_to_rad(0.0))
	amount_moved += move_speed * delta_time * _sign
	if amount_moved >= max_distance:
		amount_moved = max_distance
		_sign = -1.0
	elif amount_moved <= 0.0:
		amount_moved = 0.0
		_sign = 1.0
	var prev := t.position
	t.position = start_origin + dir * amount_moved
	last_velocity = velocity
	velocity = (t.position - prev) / delta_time
	last_position = t.position






func update_move_dir() -> void:  # C# UpdateMoveDir
	pass

var platform_size := Vector2(48, 8)
var start_origin := Vector2.ZERO
var _sign := 1.0


func _physics_process(delta: float) -> void:
	super(delta)
	if move_target == null:
		for c: Character in zone_characters:
			if is_instance_valid(c):
				c.character_inherited_motion = velocity


func on_character_entered(_c: Character) -> void:
	pass


func on_character_exited(c: Character) -> void:
	c.character_inherited_motion = Vector2.ZERO

var move_target: Node2D = null     # если задан, двигается он (например, AnimatableBody2D), а не сам блок
var initial_moved := 0.0           # с какого расстояния от края пути начинать (середина — max_distance / 2)


func reset_play_state() -> void:
	var t := move_target if move_target else self
	amount_moved = initial_moved
	_sign = 1.0
	t.position = start_origin + Vector2.RIGHT.rotated(deg_to_rad(0.0)) * amount_moved
	velocity = Vector2.ZERO
