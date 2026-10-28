# Ported from structur/UndergroundTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name UndergroundTrigger
extends Node2D

@export var fade_speed: float
@export var character_inside: bool
@export var alpha: float
var audio_under_ground: bool
var audio_underground: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass
