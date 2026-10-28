# Ported from structur/WaterSplash.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WaterSplash
extends Node2D

var animator: AnimationPlayer
var sprite_renderer: Sprite2D
var splashing: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func splash() -> void:  # C# Splash
	pass

func done_splashing() -> void:  # C# doneSplashing
	pass
