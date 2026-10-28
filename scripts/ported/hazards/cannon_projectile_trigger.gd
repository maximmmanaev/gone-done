# Ported from structur/CannonProjectileTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CannonProjectileTrigger
extends Node2D

var animal_cannon: AnimalCannon

func on_trigger_enter_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_exit_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass
