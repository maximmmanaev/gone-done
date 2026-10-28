# Ported from structur/CursorControlHints.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CursorControlHints
extends Node2D

enum Button_ {
	Inventory,
	Switch,
	Copy,
	PickUp,
	Cancel,
	Rotate,
	ShiftRotate,
}
var hint_buttons: Array
var alt_hint_buttons: Array
var cross_buttons: Array
var circle_buttons: Array
var button_map: Dictionary

func _enter_tree() -> void:  # C# Awake
	pass

func hide_all_0() -> void:  # C# HideAll
	pass

func hide_all_1(dont_hide: Array) -> void:  # C# HideAll
	pass

func set_button_visible(button, visible: bool, text_key: String) -> void:  # C# SetButtonVisible
	pass

func set_button_visible_return(button, visible: bool, text_key: String, highlighted: bool) -> CursorControlHintButton:  # C# SetButtonVisibleReturn
	return null
