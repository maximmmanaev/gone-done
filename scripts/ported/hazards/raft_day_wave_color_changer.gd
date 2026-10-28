# Ported from structur/RaftDayWaveColorChanger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RaftDayWaveColorChanger
extends Node2D

var wave_system: WaveSystem
var start_front_wave_color: Color
var start_back_wave_color: Color
var start_very_front_wave_color: Color
var end_front_wave_color: Color
var end_back_wave_color: Color
var end_very_front_wave_color: Color

func _enter_tree() -> void:  # C# Awake
	pass

func init() -> void:  # C# Init
	pass

func start_transition() -> void:  # C# StartTransition
	pass

func stop_transition() -> void:  # C# StopTransition
	pass

func handle_transition(progress: float) -> void:  # C# HandleTransition
	pass
