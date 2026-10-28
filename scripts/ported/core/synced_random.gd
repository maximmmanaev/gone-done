# Ported from structur/SyncedRandom.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SyncedRandom
extends RefCounted

var random

func range(min: float, max: float) -> float:  # C# Range
	return 0.0

func range_2(min: int, max: int) -> int:  # C# Range
	return 0

func shuffle_list(list: Array) -> void:  # C# ShuffleList
	pass
