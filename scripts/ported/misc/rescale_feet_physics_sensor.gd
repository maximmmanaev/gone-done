# Ported from structur/RescaleFeetPhysicsSensor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RescaleFeetPhysicsSensor
extends Node2D

@export var box_collider: CollisionShape2D
@export var min_y_size: float

func _process(delta: float) -> void:  # C# LateUpdate
	pass
