# Ported from structur/CanAttachIndicator.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CanAttachIndicator
extends Node2D

var honey_piece: HoneyPiece
var sprite_renderer: Sprite2D
var initial_color: Color
var current_alpha: float
@export var change_speed: float

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func set_alpha(new_alpha: float) -> void:  # C# setAlpha
	pass
