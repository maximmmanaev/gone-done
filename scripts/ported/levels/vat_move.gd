# Ported from structur/VatMove.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name VatMove
extends Node2D

var moving_up: bool
@export var move_speed: float
@export var upper_limit: float
@export var lower_limit: float
@export var pause_time: float

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func move_0():  # C# Move (coroutine)
	pass

func u_stop():  # C# Stop (coroutine)
	pass
