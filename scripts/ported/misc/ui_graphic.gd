# Ported from structur/UIGraphic.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name UIGraphic
extends UIElement

var bounding_box: AABB
var srs: Array
var imgs: Array
var txts: Array
var controller_buttons: Array
var canvas_group
@export var canvas_fade_time: float
var u_visible: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func hide_1(force_quick_hide: bool) -> void:  # C# Hide
	pass

func show_0() -> void:  # C# Show
	pass
