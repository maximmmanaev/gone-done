# Ported from structur/MsgCharacterPicked.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgCharacterPicked
extends RefCounted

var animal
var player_network_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
