# Ported from structur/PS2DPoint.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PS2DPoint
extends RefCounted

var u_position: Vector2
var curve: float
var u_name: String
var selected: bool
var clockwise: bool
var median: Vector2
var handle_p: Vector2
var handle_n: Vector2
var control_id: int
var control_pid: int
var control_nid: int
var point_type: int

func move_2(diff: Vector2, move_handles: bool) -> void:  # C# Move
	pass
