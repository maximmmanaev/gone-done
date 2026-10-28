# Ported from structur/InheritMotion.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name InheritMotion
extends Node2D

var pms: Array
var last_position: Vector2

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []
