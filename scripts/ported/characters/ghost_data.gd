# Ported from structur/GhostData.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GhostData
extends RefCounted

enum GhostEvent {
	Invalid,
	Position,
	AnimState,
	SecondaryAnim,
	Flipped,
	Zombie,
	Jetpack,
	Coin,
	Stopwatch,
}

class GhostDataPoint extends RefCounted:
	var timestamp: float
	var frame_timestamp: float
	var u_position: Vector3
	var frame_position: Vector3
	var valid: bool
	var event_vals: Dictionary
	var interpolated: bool
	func add_data(event_type, data) -> void:  # C# AddData
		pass
	func u_to_string() -> String:  # C# ToString
		return ""
	func reset_data(timestamp: float, position: Vector3, valid: bool) -> void:  # C# ResetData
		pass
	func reset_data_2(timestamp: float, frame_timestamp: float, position: Vector3, frame_position: Vector3, valid: bool) -> void:  # C# ResetData
		pass
static var type_ref: Dictionary
var data_points: Array
var last_index: int
var last_time: float
static var invalid
var animal
var outfits: Array
var player_name: String
var last_data_point  # C# property

static func get_event_data_type(event_type):  # C# GetEventDataType
	pass

func get_copy() -> GhostData:  # C# GetCopy
	return null

func set_character_info(animal, outfits_worn: Array, username: String) -> void:  # C# SetCharacterInfo
	pass

func populate_data(ghost_data: Array) -> void:  # C# PopulateData
	pass

func get_data() -> Array:  # C# GetData
	return []

func add_ghost_data(data_point) -> void:  # C# AddGhostData
	pass

func get_data_for_time(timestamp: float, interpolate: bool):  # C# GetDataForTime
	pass

func print_data() -> String:  # C# printData
	return ""
