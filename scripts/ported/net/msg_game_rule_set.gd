# Ported from structur/MsgGameRuleSet.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgGameRuleSet
extends RefCounted

var new_rule: int
var value: int
var value_2: int
var valueb: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
