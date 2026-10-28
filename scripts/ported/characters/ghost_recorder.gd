# Ported from structur/GhostRecorder.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GhostRecorder
extends Node2D

var tracked_char: Character
var tracking: bool
var paused: bool
var time_offset: float
var ghost_data: GhostData
var next_data_point
var pause_time: float
var previous_values: Dictionary
var max_ghost_distance: float
var max_dist_sq: float
var is_tracking: bool  # C# property
var tracked_character: Character  # C# property
var is_paused: bool  # C# property
var current_ghost_data: GhostData  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func update_previous_values() -> void:  # C# updatePreviousValues
	pass

func reset_previous_values() -> void:  # C# resetPreviousValues
	pass

func track_character(character_to_track: Character) -> void:  # C# TrackCharacter
	pass

func start_tracking_1(character_to_track: Character) -> void:  # C# StartTracking
	pass

func start_tracking_0() -> void:  # C# StartTracking
	pass

func update_character() -> void:  # C# UpdateCharacter
	pass

func pause_tracking() -> void:  # C# PauseTracking
	pass

func resume_tracking() -> void:  # C# ResumeTracking
	pass

func stop_tracking() -> void:  # C# StopTracking
	pass

func print_current_data() -> String:  # C# PrintCurrentData
	return ""

func serialize_data() -> Array:  # C# SerializeData
	return []
