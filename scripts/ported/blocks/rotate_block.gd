# Ported from structur/RotateBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RotateBlock
extends ActiveBlock

@export var degrees: float
@export var rotate_speed: float
@export var interval: float
@export var center_of_rotation: Vector3
@export var clockwise: bool
@export var is_anchor: bool
@export var spinner: Node2D
@export var rotation_sound_event: String
@export var constant_sound: bool
var rotate_time: float
var rotate_amt: float
@export var real: bool
@export var placement_indicator_initial_scale: float
@export var counter_rotate_holder: Node2D
var sound_timer: float
@export var sound_timer_interval: float
var rb: RigidBody2D
var rb_spinner: RigidBody2D

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func enable_placement(show_guides: bool) -> void:  # C# EnablePlacement
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func activate_0() -> void:  # C# Activate
	pass

func place_1(player_number: int) -> void:  # C# Place
	pass

func flip(sprint: bool) -> void:  # C# Flip
	pass

func update_placement_guides() -> void:  # C# UpdatePlacementGuides
	pass

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []
