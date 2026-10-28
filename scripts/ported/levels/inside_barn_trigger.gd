# Ported from structur/InsideBarnTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name InsideBarnTrigger
extends Node2D

@export var barnfront: Sprite2D
var all_sprites: Array
var show_sprites: Array
@export var fade_speed: float
@export var character_inside: bool

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass
