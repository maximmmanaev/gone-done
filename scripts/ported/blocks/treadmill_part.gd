# Ported from structur/TreadmillPart.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name TreadmillPart
extends MultipiecePart

var last_position: Vector2
var last_position_2: Vector2
var velocity: Vector2
var angular_vel: float
var last_angle: float
var last_angle_2: float
@export var track: bool

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func calculate_physics_values() -> void:  # C# CalculatePhysicsValues
	pass

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []
