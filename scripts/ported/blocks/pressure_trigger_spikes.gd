# Ported from structur/PressureTriggerSpikes.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PressureTriggerSpikes
extends ActiveBlock

@export var animator: AnimationPlayer
var trigger: CheckColliding
@export var triggered: bool
var lock_out_timer: float
@export var lock_out_time: float
var death_trigger_once: bool

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func activate_0() -> void:  # C# Activate
	pass

func enable_0() -> void:  # C# Enable
	pass

func spikes_over() -> void:  # C# SpikesOver
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
