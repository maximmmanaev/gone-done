# Ported from structur/LoopArraysAndLists.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name LoopArraysAndLists
extends RefCounted

static func loop_id(list, i: int) -> int:  # C# LoopID
	return 0

static func loop(list, i: int):  # C# Loop
	pass

static func loop_id_2(array: Array, i: int) -> int:  # C# LoopID
	return 0

static func loop_2(array: Array, i: int):  # C# Loop
	pass
