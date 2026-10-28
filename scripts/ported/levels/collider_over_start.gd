# Ported from structur/ColliderOverStart.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ColliderOverStart
extends Node2D

var over_start_zone: bool  # C# property

func on_trigger_enter_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
