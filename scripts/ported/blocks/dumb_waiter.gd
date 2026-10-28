# Ported from structur/DumbWaiter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DumbWaiter
extends ActiveBlock

@export var animator: AnimationPlayer
@export var motor_animator: AnimationPlayer
var last_position: Vector2
var velocity: Vector2
var last_velocity: Vector2
@export var movement_activated: bool
@export var net_movement_delay: float

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func go() -> void:  # C# Go
	pass

func start_movement() -> void:  # C# StartMovement
	pass

func delay_start_animator(time: float):  # C# DelayStartAnimator (coroutine)
	pass

func movement_done() -> void:  # C# MovementDone
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

func handle_event(e) -> void:  # C# handleEvent
	pass
