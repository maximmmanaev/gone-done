# Ported from structur/RaftDayNightHSVChanger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RaftDayNightHSVChanger
extends Node2D

static var u_color: int
static var hue_shift_amount: int
static var sat_shift_amount: int
static var val_shift_amount: int
static var contrast_shift_amount: int
var start_color
var end_color
var renderer: Sprite2D

func _enter_tree() -> void:  # C# Awake
	pass

func handle_transition(progress: float) -> void:  # C# HandleTransition
	pass
