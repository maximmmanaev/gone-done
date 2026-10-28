# Ported from structur/Tentacle.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Tentacle
extends Node2D

var tentacle_top: Node2D
var tentacle_warning_prefab: Node2D
var base_start_range: float
var base_end_range: float
var top_start_range: float
var top_end_range: float
var base_speed: float
var top_speed: float
var maximum_position_y: float
var minimum_position_y: float
var hidden_position_y: float
var y_position_oscillation: float
var time_to_show: float
var time_to_hide: float
var time_to_simulate: float
var random: SyncedRandom
var u_transform: Node2D
var tentacle_warning: GPUParticles2D
var end_position: float
var oscillation_factor: float
var simulation_time: float
var base_time: float
var top_time: float
var start_time: float
var simulating: bool

func _enter_tree() -> void:  # C# Awake
	pass

func start_tentacle() -> void:  # C# StartTentacle
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func check_is_simulating() -> bool:  # C# CheckIsSimulating
	return false

func oscillate_position() -> void:  # C# OscillatePosition
	pass

func handle_show() -> void:  # C# HandleShow
	pass

func handle_hide() -> void:  # C# HandleHide
	pass

func update_tentacle_transform(trans: Node2D, speed: float, range_start: float, range_end: float, time: float) -> void:  # C# UpdateTentacleTransform
	pass

func show_warning() -> void:  # C# ShowWarning
	pass

func set_random(random: SyncedRandom) -> void:  # C# SetRandom
	pass
