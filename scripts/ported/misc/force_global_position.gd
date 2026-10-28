# Ported from structur/ForceGlobalPosition.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ForceGlobalPosition
extends Node2D

@export var x: bool
@export var y: bool
@export var z: bool
@export var u_position: Vector3
var fixed_position: Vector3

func _process(delta: float) -> void:  # C# Update
	pass
