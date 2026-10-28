# Ported from structur/PlaceableMetadataList.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PlaceableMetadataList
extends Node2D

var all_block_prefabs: Array
var extra_blocks: Array
var random_groups: Array
var special_groups: Array
var teleporter_prefab_metadata: PlaceableMetadata
static var instance: PlaceableMetadataList
var cached_block_map: Dictionary
var name_to_index_map: Dictionary
var placeable_variants: Dictionary

func _enter_tree() -> void:  # C# Awake
	pass

func get_prefab_for_placeable_index(idx: int):  # C# GetPrefabForPlaceableIndex
	pass

func get_index_for_placeable(name: String) -> int:  # C# GetIndexForPlaceable
	return 0

func get_placeable_by_index(idx: int) -> Placeable:  # C# GetPlaceableByIndex
	return null

func get_pickable_by_index(idx: int) -> PickableBlock:  # C# GetPickableByIndex
	return null

func all_block_list_length() -> int:  # C# AllBlockListLength
	return 0

func find_variant_index(variant_placeable: Placeable) -> int:  # C# FindVariantIndex
	return 0

func get_pickable_for_variant_index(base_pickable: PickableBlock, variant_index: int) -> PickableBlock:  # C# GetPickableForVariantIndex
	return null
