# Ported from structur/Blackhole.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Blackhole
extends ActiveBlock

@export var pull_strength: float
var gravity_curve: Curve
@export var shrink_time: float
@export var death_distance: float
@export var rotate_spin_speed: float
@export var kill_offset: Vector3
@export var cutoff_distance_sqr: float
@export var death_cause_name: String
@export var blackhole_burst_prefab: Node2D
var current_blackhole_burst: blackholeBurst
@export var blackhole_burst_filled: bool
@export var blackhole_burst_timer: float
@export var blackhole_burst_time: float
var currently_sucking: Array
var animator: AnimationPlayer

func _ready() -> void:  # C# Start
	pass

func enable_0() -> void:  # C# Enable
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func suck_in_character(chr: Character):  # C# suckInCharacter (coroutine)
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
