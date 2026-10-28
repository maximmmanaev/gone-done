# Ported from structur/MsgAFKPlayer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgAFKPlayer
extends RefCounted

var is_afk: bool
var player_network_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
