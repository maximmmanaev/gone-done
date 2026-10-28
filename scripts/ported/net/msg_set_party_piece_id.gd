# Ported from structur/MsgSetPartyPieceID.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgSetPartyPieceID
extends RefCounted

var network_player_number: int
var piece_id: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
