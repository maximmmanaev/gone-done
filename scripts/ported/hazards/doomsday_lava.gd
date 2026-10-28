# Ported from structur/DoomsdayLava.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DoomsdayLava
extends Node2D

enum Direction {
	Up,
	Down,
	Left,
	Right,
}
var lava_direction
@export var extra_padding: Vector2
@export var level_size: Vector2
@export var lava_start: Vector2
@export var lava_end: Vector2
@export var lava_rot: float
@export var wave_element_width: float
@export var lava_speed_multiplier: float
var subwave_offsets: Array
var subwave_scales: Array
var subwave_animation_speeds: Array
var subwaves: Array
var wave_elements: Array
var wave_colors: Array
var bottom_sprites: Array
var generated_elements: Array
@export var hazard_collider: CollisionShape2D
var over_start_obj: ColliderOverStart
var wwise_game_object
var over_start_zone: bool  # C# property

func initialize_0() -> void:  # C# Initialize
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func reset_prefab() -> void:  # C# ResetPrefab
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass
