# Ported from structur/DoorAnimatorEvents.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DoorAnimatorEvents
extends Node2D

var door: AutoDoor

func enable_door_collider() -> void:  # C# enableDoorCollider
	pass

func disable_door_collider() -> void:  # C# disableDoorCollider
	pass
