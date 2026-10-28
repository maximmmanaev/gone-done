# Ported from structur/Stopwatch.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Stopwatch
extends ActiveBlock

@export var pickup_effect: Node2D
var start_position: Vector3
var animator: AnimationPlayer
var time_slow_curve: Curve
@export var slow_ramp_time: float
@export var slow_duration: float
@export var slow_speed: float
var triggered: bool
var always_respawn: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func trigger_slowdown() -> void:  # C# triggerSlowdown
	pass

func activate_0() -> void:  # C# Activate
	pass

func disable_0() -> void:  # C# Disable
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass
