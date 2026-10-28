# Ported from structur/MsgPiecePicked.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPiecePicked
extends RefCounted

var pickable_net_id: int
var player_number: int
var piece_id: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
