# Ported from structur/ColoredThings.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ColoredThings
extends RefCounted

var description: String
var color_a: Color
var color_b: Color
var holder: Node2D
var sprite_renderers: Array
var texts: Array
var on: bool

func initilize_colored_thing() -> void:  # C# InitilizeColoredThing
	pass

func update_color_array() -> void:  # C# UpdateColorArray
	pass

func update_array_alpha(input: float) -> void:  # C# UpdateArrayAlpha
	pass

func new_alpha(input_color: Color, alpha: float) -> Color:  # C# newAlpha
	return Color.WHITE
