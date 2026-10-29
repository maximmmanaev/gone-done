# Каркас из structur/Treadmill.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
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


func recalculate_collider_positions() -> void:  # C# RecalculateColliderPositions
	pass

func activate_sound() -> void:  # C# activateSound
	pass


func act(delta_time: float) -> void:  # C# Act
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.character_inherited_motion = belt_dir * belt_speed









func reset_part_positions() -> void:  # C# ResetPartPositions
	pass

func update_part_positions() -> void:  # C# UpdatePartPositions
	pass

func set_part_transform(t: float, treadmill_base_rotation: float, part_rb: RigidBody2D) -> void:  # C# SetPartTransform
	pass

var belt_dir := Vector2.RIGHT
var belt_speed := 60.0


func on_character_entered(_c: Character) -> void:
	pass


func on_character_exited(c: Character) -> void:
	c.character_inherited_motion = Vector2.ZERO
