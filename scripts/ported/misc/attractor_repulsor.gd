# Ported from structur/AttractorRepulsor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AttractorRepulsor
extends Node2D

@export var radius: float
@export var inner_radius: float
@export var push_accel: float
var distance_factor: Curve
@export var center_rotate_delay: float
var affected_projectiles: Array
var destroyed_projectiles: Array
var pause_attraction: bool

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
