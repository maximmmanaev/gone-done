# Ported from structur/MsgClientKicked.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgClientKicked
extends RefCounted

var network_player_number: int
var kick_reason

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
