# Ported from structur/RaftDayNightColorChanger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RaftDayNightColorChanger
extends Node2D

var renderers: Array
var start_color: Color
var end_color: Color

func _enter_tree() -> void:  # C# Awake
	pass

func handle_transition(progress: float) -> void:  # C# HandleTransition
	pass
