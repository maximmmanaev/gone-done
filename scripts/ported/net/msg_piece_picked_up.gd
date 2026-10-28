# Ported from structur/MsgPiecePickedUp.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPiecePickedUp
extends RefCounted

var player_number: int
var piece_id: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
