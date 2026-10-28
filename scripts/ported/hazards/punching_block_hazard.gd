# Ported from structur/PunchingBlockHazard.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingBlockHazard
extends Node2D

var punching_block: PunchingBlock
@export var strength: float
@export var teleport_dist: float
@export var raycast_start_dist: float
@export var character_thickness: float
var wall_raycast_mask

func on_trigger_enter_2d(collider: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
