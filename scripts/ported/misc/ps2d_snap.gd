# Ported from structur/PS2DSnap.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PS2DSnap
extends RefCounted

var snap_distance: float
var axes: Array
var snap_location: Vector2
var snap_point_1: int
var snap_point_2: int
var snap_axis_1: int
var snap_axis_2: int

func check_point(point_id: int, point_dragging: Vector2, point_static: Vector2) -> void:  # C# CheckPoint
	pass

func get_closest_axes() -> int:  # C# GetClosestAxes
	return 0
