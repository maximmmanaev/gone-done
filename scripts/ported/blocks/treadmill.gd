# Ported from structur/Treadmill.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Treadmill
extends MultipieceBlock

@export var treadmill_animator: AnimationPlayer
@export var large_collider: CollisionShape2D
@export var treadmill_sound_event: String
@export var animation_speed: float
@export var animation_on: bool
@export var animation_timestamp: float
@export var inner_radius: float
@export var full_revolution_time: float
var mass_speed_ratio: float
var collider_positions: Array
var collider_angles: Array
var parts_rb: Array

func _enter_tree() -> void:  # C# Awake
	pass

func recalculate_collider_positions() -> void:  # C# RecalculateColliderPositions
	pass

func activate_sound() -> void:  # C# activateSound
	pass

func activate_0() -> void:  # C# Activate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func enable_placement(show_guides: bool) -> void:  # C# EnablePlacement
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func can_place() -> bool:  # C# CanPlace
	return false

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func reset_part_positions() -> void:  # C# ResetPartPositions
	pass

func update_part_positions() -> void:  # C# UpdatePartPositions
	pass

func set_part_transform(t: float, treadmill_base_rotation: float, part_rb: RigidBody2D) -> void:  # C# SetPartTransform
	pass
