# Ported from structur/MetroTrainWagon.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MetroTrainWagon
extends Node2D

var metro_move: MetroTrainMove
var check_colliding: CheckColliding
@export var velocity_inheritance_ratio: float
var character_on_wagon_last_frame: Array
var leaving_wagon_chars: Array

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass
