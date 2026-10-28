# Ported from structur/MsgPiecePlaced.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPiecePlaced
extends RefCounted

var player_number: int
var piece_position: Vector3
var piece_scale: Vector3
var piece_rotation: Quaternion
var piece_id: int
var piece_was_moved: bool
var reset_position: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
