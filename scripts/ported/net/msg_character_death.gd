# Ported from structur/MsgCharacterDeath.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgCharacterDeath
extends RefCounted

var player_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
