# Ported from structur/IceKiller.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name IceKiller
extends Node2D

@export var ice_cube: Node2D
@export var ice_killer: Node2D

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func on_collision_enter_2d(ice_killer) -> void:  # C# OnCollisionEnter2D
	pass
