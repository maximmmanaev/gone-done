# Ported from structur/MsgBookPiecePicked.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgBookPiecePicked
extends RefCounted

var piece_number: int
var network_player_number: int
var u_set_transform: bool
var piece_position: Vector3
var piece_scale: Vector3
var piece_rotation: Quaternion
var piece_id: int
var piece_rotation_direction
var can_set_custom_color: bool
var custom_color: Color
var damage_level: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
