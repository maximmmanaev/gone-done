# Ported from structur/IcebergMove.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name IcebergMove
extends ActiveBlock

@export var blade_speed: float
@export var blade_animator: AnimationPlayer
var initial_position: Vector3
var time_moving: float
var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
var new_velocity: Vector2
@export var iceberg_animator: AnimationPlayer
@export var start_sound_fx_string: String
@export var stop_sound_fx_string: String

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func activate_0() -> void:  # C# Activate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []
