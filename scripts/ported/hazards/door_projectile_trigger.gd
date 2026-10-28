# Ported from structur/DoorProjectileTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DoorProjectileTrigger
extends Node2D

var door: AutoDoor

func on_trigger_enter_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_stay_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func can_touch_trigger(collision: CollisionShape2D) -> bool:  # C# CanTouchTrigger
	return false
