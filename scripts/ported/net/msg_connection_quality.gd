# Ported from structur/MsgConnectionQuality.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgConnectionQuality
extends RefCounted

var network_player_number: int
var quality

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
