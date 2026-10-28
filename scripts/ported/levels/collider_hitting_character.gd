# Ported from structur/ColliderHittingCharacter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ColliderHittingCharacter
extends Node2D

@export var center_of_mass: Node2D
var previous_center_of_mass: Vector3
var velocity: Vector3
@export var ignore_com: bool
@export var strength: float
@export var extra_up: float

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass
