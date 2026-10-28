# Ported from structur/AttachmentIndicator.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AttachmentIndicator
extends Node2D

var attachement_parts: Array
var sprite_renderer: Sprite2D
var initial_sprite: Texture2D
@export var is_on: bool

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass
