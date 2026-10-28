# Ported from structur/NameTag.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name NameTag
extends Node2D

@export var name_box: Label
var name_canvas_group
var canvas: CanvasLayer
@export var uch_net_icon: TextureRect
@export var psn_verified_icon: TextureRect
var last_alpha: float
@export var current_alpha: float
@export var max_opacity: float
var currentname: String  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func update_icons_1(lp) -> void:  # C# UpdateIcons
	pass

static func update_icons_4(lp, uch_net_icon: TextureRect, psn_verified_icon: TextureRect, use_player_color: bool) -> void:  # C# UpdateIcons
	pass

func set_name_box_text(new_name: String, chr: Character) -> void:  # C# setNameBoxText
	pass

func set_name_box_text_2(new_name: String, cursor: CursorUnity) -> void:  # C# setNameBoxText
	pass

func match_layer_order(sr: Sprite2D) -> void:  # C# MatchLayerOrder
	pass
