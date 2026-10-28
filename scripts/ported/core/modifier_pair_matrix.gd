# Ported from structur/ModifierPairMatrix.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ModifierPairMatrix
extends RefCounted

const MOD_START_IND: int = 1000
static var values
static var value_sums: Array
static var modifier_count: int

static func get_value(modifier_1: int, modifier_2: int, normalize: bool) -> float:  # C# GetValue
	return 0.0

static func get_value_2(mod_index_1: int, mod_index_2: int, normalize: bool) -> float:  # C# GetValue
	return 0.0
