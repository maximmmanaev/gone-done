# Ported from structur/MsgPlayerSkillUpdated.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgPlayerSkillUpdated
extends RefCounted

var network_player_number: int
var skill_mean: float
var skill_std_dev: float

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
