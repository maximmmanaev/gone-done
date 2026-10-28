# Ported from structur/MsgUnlockAvailable.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgUnlockAvailable
extends RefCounted

var unlock_type
var associated_character
var associated_level
var outfit_number: int
var display_name: String
var connid: int
var player_local_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
