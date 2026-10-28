# Ported from structur/WeightedBlockList.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WeightedBlockList
extends RefCounted

class WeightedBlock extends RefCounted:
	var placeable: Placeable
	var weight: int
var weighted_blocks: Array
var placeable_2idx: Dictionary
var total_weight: int
var max_weight: int
var is_empty: bool  # C# property

func add_weight(idx: int, placeable: Placeable, weight: int) -> void:  # C# AddWeight
	pass

func get_weight_for_placeable(placeable: Placeable) -> int:  # C# GetWeightForPlaceable
	return 0

func get_max_weight() -> int:  # C# GetMaxWeight
	return 0

func get_random_index() -> int:  # C# GetRandomIndex
	return 0

func get_random_placeable_prefab() -> Placeable:  # C# GetRandomPlaceablePrefab
	return null

func clone() -> WeightedBlockList:  # C# Clone
	return null

func apply_skew(match_tag, multiplier: float) -> void:  # C# ApplySkew
	pass

func apply_skew_not(not_tag, multiplier: float) -> void:  # C# ApplySkewNot
	pass

func apply_area_skew_above(area_value: float, multiplier: float) -> void:  # C# ApplyAreaSkewAbove
	pass

func apply_area_skew_below(area_value: float, multiplier: float) -> void:  # C# ApplyAreaSkewBelow
	pass

func recompute_total_weights() -> void:  # C# RecomputeTotalWeights
	pass
