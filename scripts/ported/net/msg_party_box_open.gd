# Ported from structur/MsgPartyBoxOpen.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPartyBoxOpen
extends RefCounted

var is_open: bool
var is_extra_box: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
