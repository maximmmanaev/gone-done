# Ported from structur/Fly.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Fly
extends Node2D

var follow_target: Character
var target_position: Vector3
var fly_follow_speed: Curve
var custom_animator: GrassAnimator
var fly_1: Array
var fly_2: Array
var fly_3: Array
var fly_4: Array
@export var sr: Sprite2D
@export var follow_offset: Vector3

func _process(delta: float) -> void:  # C# Update
	pass

func initialize_1(follow_chr: Character) -> void:  # C# Initialize
	pass
