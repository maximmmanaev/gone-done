# Ported from structur/CharacterGapLifter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CharacterGapLifter
extends Node2D

var ray_origins: Array
var layer_mask
@export var raycast_length: float
@export var last_collision_distance: float
@export var margin: float
@export var speed_check: bool
@export var inside_wall_check: bool
@export var obstacle_straight_down: bool
@export var both_colliders_hitting: bool
var hit: Array

func can_float() -> bool:  # C# CanFloat
	return false
