# Ported from structur/MsgPieceDestroyed.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPieceDestroyed
extends RefCounted

var block_id: int
var scene_load_number: int
var machine_network_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
