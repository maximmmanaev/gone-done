# Ported from structur/CollisionPiece.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CollisionPiece
extends Node2D

@export var colliding: bool
@export var colliding_wall: bool
@export var colliding_hazard: bool
static var option_a_check_mask: int
static var option_a_ignore_mask: int
static var option_b_mask: int
static var option_c_mask: int

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass
