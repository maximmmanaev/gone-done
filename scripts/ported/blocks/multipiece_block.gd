# Каркас из structur/MultipieceBlock.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name MultipieceBlock
extends ActiveBlock

@export var use_sprite_parts: bool
@export var left: Texture2D
@export var center: Texture2D
@export var right: Texture2D
@export var single: Texture2D
var parts: Array
@export var separable: bool


func _process(delta: float) -> void:  # C# Update
	pass







func can_place_with_parts() -> bool:  # C# CanPlaceWithParts
	return false



func remove_part(part: MultipiecePart) -> void:  # C# RemovePart
	pass






func get_children_and_parts() -> Array:  # C# GetChildrenAndParts
	return []

func tint() -> void:  # C# Tint
	pass
