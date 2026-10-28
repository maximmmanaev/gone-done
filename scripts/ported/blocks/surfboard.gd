# Ported from structur/Surfboard.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Surfboard
extends ActiveBlock

@export var surfboard_animator: AnimationPlayer
var initial_position: Vector3
var last_position: Vector2
var velocity: Vector2
var moving: bool
@export var move_speed: float

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func attach_to_wave(wave: Node2D) -> void:  # C# AttachToWave
	pass

func start_moving() -> void:  # C# StartMoving
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func sprite_assignment_rule(sr: Sprite2D) -> void:  # C# SpriteAssignmentRule
	pass
