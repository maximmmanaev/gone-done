# Ported from structur/MsgSetBlockFrequency.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgSetBlockFrequency
extends RefCounted

var block_index: int
var frequency: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
