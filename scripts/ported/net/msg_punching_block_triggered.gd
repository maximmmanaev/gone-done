# Ported from structur/MsgPunchingBlockTriggered.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPunchingBlockTriggered
extends RefCounted

var block_id: int
var player_number: int
var hit_trigger_mask: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
