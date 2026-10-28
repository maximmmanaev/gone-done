# Ported from structur/AirplaneProjectileTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AirplaneProjectileTrigger
extends Node2D

var airplane: Projectile

func on_trigger_enter_2d(collider: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
