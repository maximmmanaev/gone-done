# Ported from structur/PlaceableMetadata.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PlaceableMetadata
extends Node2D

@export var block_serialize_index: int
@export var is_level_geometry: bool
var placeable_ref: Placeable
var attachment_points: Array
var sub_elements: Array
