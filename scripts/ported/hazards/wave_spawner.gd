# Ported from structur/WaveSpawner.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WaveSpawner
extends Node2D

@export var wave_of_doom: Node2D
@export var starting_point: Node2D
@export var end_point: float
@export var start_point: float

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass
