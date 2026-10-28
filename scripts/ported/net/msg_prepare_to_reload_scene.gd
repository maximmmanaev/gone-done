# Ported from structur/MsgPrepareToReloadScene.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPrepareToReloadScene
extends RefCounted

var reload_to_mode
var snapshot_info

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
