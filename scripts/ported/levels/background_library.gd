# Ported from structur/BackgroundLibrary.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name BackgroundLibrary
extends Node2D

static var instance: BackgroundLibrary
var backgrounds: Array

func _enter_tree() -> void:  # C# Awake
	pass

func get_background(background: int) -> CustomBackground:  # C# GetBackground
	return null
