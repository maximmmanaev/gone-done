# Ported from structur/MsgPlayerHandicapSet.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPlayerHandicapSet
extends RefCounted

var handicap: int
var network_player_number: int
var action

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
