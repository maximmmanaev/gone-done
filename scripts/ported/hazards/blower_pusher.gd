# Ported from structur/BlowerPusher.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name BlowerPusher
extends Node2D

@export var strength: float
@export var max_air_speed: float
@export var max_reverse_air_push_back: float
@export var speed_in_common_factor: float
var distance_factor: Curve
var offcenter_factor: Curve
@export var blower_direction_target: Node2D
@export var blower_base: Node2D
@export var blower_perpendicular: Node2D
@export var projectile_pusher: bool
var affected_projectiles: Array
var affected_characters: Array
var affected_characters_last_frame: Array
var destroyed_projectiles: Array
var layer_mask
var pause_attraction: bool

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
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
