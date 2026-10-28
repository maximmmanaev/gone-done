# Ported from structur/MovingLevelBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MovingLevelBlock
extends MultipiecePart

var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
var new_velocity: Vector2
@export var custom_attached_sprite_layer: String

func _enter_tree() -> void:  # C# Awake
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func sprite_assignment_rule(sr: Sprite2D) -> void:  # C# SpriteAssignmentRule
	pass
