# Ported from structur/RaftDayNightCycle.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RaftDayNightCycle
extends Node2D

static var instance: RaftDayNightCycle
var sky_renderer: Sprite2D
var sky_gradient
var transition_time: float
@export var day_night_progress: float
var color_changers: Array
var hsv_changers: Array
var wave_color_changers: RaftDayWaveColorChanger
var setupped: bool

func _enter_tree() -> void:  # C# Awake
	pass

func init() -> void:  # C# Init
	pass

func night_transition() -> void:  # C# NightTransition
	pass

func day_transition() -> void:  # C# DayTransition
	pass

func do_transition(start: float, end: float):  # C# DoTransition (coroutine)
	pass

func update_colors() -> void:  # C# UpdateColors
	pass
