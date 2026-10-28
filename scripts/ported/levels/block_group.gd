# Ported from structur/BlockGroup.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name BlockGroup
extends Node2D

var required_blocks: Array
var random_pool: Array
@export var challenge: float
@export var challenge_range: float
@export var area: float
@export var area_range: float
var number_unique_blocks: int
var number_unique_blocks_filtered: int
var weighted_list: WeightedBlockList
var lacks_variety: bool  # C# property
var has_blocks_after_filtering: bool  # C# property

func filter_pool() -> int:  # C# filterPool
	return 0

static func get_item_filter_weight(placeable_prefab: Placeable, weight: int) -> int:  # C# GetItemFilterWeight
	return 0

func get_random_pickable_block_prefab() -> PickableBlock:  # C# GetRandomPickableBlockPrefab
	return null

func get_random_pickable_block_prefab_unfiltered() -> PickableBlock:  # C# GetRandomPickableBlockPrefabUnfiltered
	return null
