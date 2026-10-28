# Ported from structur/WaveMove.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WaveMove
extends ActiveBlock

@export var move_speed: float
@export var start_time: float
@export var end_x_pos: float
var surfboard: Surfboard
var start_timer: float
var initial_position: Vector3
var velocity: Vector3
var last_position: Vector3

func _ready() -> void:  # C# Start
	pass

func activate_0() -> void:  # C# Activate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func attach_surfboard() -> void:  # C# AttachSurfboard
	pass

func sprite_assignment_rule(sr: Sprite2D) -> void:  # C# SpriteAssignmentRule
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
