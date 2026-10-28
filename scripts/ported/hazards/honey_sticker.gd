# Ported from structur/HoneySticker.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name HoneySticker
extends Node2D

@export var animator: AnimationPlayer
@export var sticky_target: Node2D
@export var following_character: bool
var u_offset: float
var u_scale: float

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func trigger_honey_stick(sticky_target: Node2D) -> void:  # C# triggerHoneyStick
	pass
