# Ported from structur/ProjectileDebris.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ProjectileDebris
extends Node2D

@export var explosion_particle: Node2D
@export var particle_scale_factor: float

func _enter_tree() -> void:  # C# Awake
	pass
