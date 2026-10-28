# Ported from structur/GrassAnimator.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GrassAnimator
extends Node2D

@export var framerate: float
var grass_sprite_animation: Array
var grass_sr: Array
var grass_num: Array
var update_grass_coroutine
var waiter
@export var loop: bool
var initialized: bool

func _ready() -> void:  # C# Start
	pass

func on_enable() -> void:  # C# OnEnable
	pass

func update_grass():  # C# UpdateGrass (coroutine)
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass
