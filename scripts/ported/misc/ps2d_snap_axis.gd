# Ported from structur/PS2DSnapAxis.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PS2DSnapAxis
extends RefCounted

var snap_point: int
var snap_dist: float
var snap_size: float
var base_location: Vector2
var direction: Vector2

func check_point(point_id: int, point_dragging: Vector2, point_static: Vector2) -> void:  # C# CheckPoint
	pass

func get_point(b_1: Vector2, b_2: Vector2, t: Vector2) -> Vector2:  # C# GetPoint
	return Vector2.ZERO

func get_intersection(another: PS2DSnapAxis) -> Vector2:  # C# GetIntersection
	return Vector2.ZERO

func line_intersection_point(l_1s: Vector2, l_1e: Vector2, l_2s: Vector2, l_2e: Vector2) -> Vector2:  # C# LineIntersectionPoint
	return Vector2.ZERO
