# Ported from structur/PartyModeColor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyModeColor
extends RefCounted

var sprite_renderers: Array
var initial_color: Color
var target_color: Color
var current_color: Color
var color_group_holders: Array
var shared_materials: Array

func set_initial_color() -> Color:  # C# setInitialColor
	return Color.WHITE

func u_set_color(t: float) -> void:  # C# SetColor
	pass

func set_color_editor_mode(t: float) -> void:  # C# SetColorEditorMode
	pass
