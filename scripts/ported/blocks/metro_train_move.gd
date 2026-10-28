# Ported from structur/MetroTrainMove.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MetroTrainMove
extends ActiveBlock

@export var metro_train_animator: AnimationPlayer
@export var start_sound_fx_string: String
@export var stop_sound_fx_string: String
var last_position: Vector2
var velocity: Vector2
var colliders: Array

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func activate_0() -> void:  # C# Activate
	pass

func time_to_wait_for_reset_reactivation():  # C# TimeToWaitForResetReactivation
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
