# Ported from structur/SmokeEffect.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SmokeEffect
extends Node2D

var animator: AnimationPlayer
@export var sprite_renderer: Sprite2D
@export var position_offset: Vector3
@export var default_scale: Vector3

func _enter_tree() -> void:  # C# Awake
	pass

func poof() -> void:  # C# Poof
	pass

func done_poofing() -> void:  # C# donePoofing
	pass
