# Ported from structur/IceSpawner.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name IceSpawner
extends Node2D

@export var ice_cube: Node2D
@export var time_delay: int
@export var range_x_lower_limit: float
@export var range_x_upper_limit: float
@export var range_y_lower_limit: float
@export var range_y_upper_limit: float

func _ready() -> void:  # C# Start
	pass

func example():  # C# Example (coroutine)
	pass

func _process(delta: float) -> void:  # C# Update
	pass
