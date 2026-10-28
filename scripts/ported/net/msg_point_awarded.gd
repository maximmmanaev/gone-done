# Ported from structur/MsgPointAwarded.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPointAwarded
extends RefCounted

var player_number: int
var point_type
var always_award: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
