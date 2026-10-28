# Ported from structur/CursorControlHintButton.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CursorControlHintButton
extends Node2D

var button
@export var button_text: Label
var visible_cache: bool
var highlight_cache: bool
var string_cache: String
@export var image: TextureRect
var default_image_color: Color
var default_text_color: Color
@export var highlight_image_color: Color
@export var highlight_text_color: Color

func _enter_tree() -> void:  # C# Awake
	pass

func u_set_visible(visible: bool, text_key: String, highlighted: bool) -> void:  # C# SetVisible
	pass
