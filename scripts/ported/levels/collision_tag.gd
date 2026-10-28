# Ported from structur/CollisionTag.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CollisionTag
extends Node2D

var bit_mask

func calculate_bit_mask():  # C# CalculateBitMask
	pass

func contains_any_tag(tag) -> bool:  # C# ContainsAnyTag
	return false

func contains_any_tag_2(tag: int) -> bool:  # C# ContainsAnyTag
	return false

func contains_all_tags(mask) -> bool:  # C# ContainsAllTags
	return false

func contains_all_tags_2(mask: int) -> bool:  # C# ContainsAllTags
	return false

func exact_tag_match(tag) -> bool:  # C# ExactTagMatch
	return false
