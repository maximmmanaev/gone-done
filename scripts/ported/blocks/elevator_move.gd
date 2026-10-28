# Ported from structur/ElevatorMove.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ElevatorMove
extends ActiveBlock

var initial_position: Vector3
var time_moving: float
var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
var new_velocity: Vector2
@export var elevator_animator: AnimationPlayer
@export var opening_wall: Node2D
var animating: bool

func _ready() -> void:  # C# Start
	pass

func activate_0() -> void:  # C# Activate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func stop_elevator() -> void:  # C# StopElevator
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func to_sudden_death() -> void:  # C# ToSuddenDeath
	pass

func instant_reset() -> void:  # C# InstantReset
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass
