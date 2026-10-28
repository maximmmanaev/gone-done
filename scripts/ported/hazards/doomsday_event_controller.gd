# Ported from structur/DoomsdayEventController.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DoomsdayEventController
extends Node2D

var paused: bool
var meteor_prefabs: Array
var meteor_rng
var meteors_on: bool
var meteors: Array
var meteor_frame_counter: int
var meteor_anim
var lava_prefab: DoomsdayLava
var lava_instance: DoomsdayLava
var lava_on: bool
var lava_frame_counter: int
var lava_anim

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func start_doomsday_stuff() -> void:  # C# StartDoomsdayStuff
	pass

func reset_doomsday_stuff() -> void:  # C# ResetDoomsdayStuff
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func start_meteors() -> void:  # C# StartMeteors
	pass

func start_lava() -> void:  # C# StartLava
	pass

func stop_meteors() -> void:  # C# StopMeteors
	pass

func stop_lava() -> void:  # C# StopLava
	pass

func get_random_meteor_int(range_start: int, range_end: int) -> int:  # C# GetRandomMeteorInt
	return 0

func get_random_meteor_prefab() -> DoomsdayMeteor:  # C# GetRandomMeteorPrefab
	return null

func get_random_meteor_float() -> float:  # C# GetRandomMeteorFloat
	return 0.0

func lava_animator():  # C# LavaAnimator (coroutine)
	pass

func meteor_generator():  # C# MeteorGenerator (coroutine)
	pass
