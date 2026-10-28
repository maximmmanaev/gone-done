# Ported from structur/CameraShaker.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CameraShaker
extends Node2D

@export var target_transform: Node2D
@export var shake_amount: float
var initial_position: Vector3
var shake_timer: float
var animator: AnimationPlayer
var is_paused: bool

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func pause_shake() -> void:  # C# PauseShake
	pass

func un_pause_shake() -> void:  # C# UnPauseShake
	pass

func force_stop() -> void:  # C# ForceStop
	pass

func start_shake(duration: float) -> void:  # C# StartShake
	pass
