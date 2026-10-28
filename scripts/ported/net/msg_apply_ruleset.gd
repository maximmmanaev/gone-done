# Ported from structur/MsgApplyRuleset.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgApplyRuleset
extends RefCounted

var ruleset_xml: String
var premade_idx: int
var apply_rules: bool
var apply_points: bool
var apply_blocks: bool
var apply_mods: bool
var temporary: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
