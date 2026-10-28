# Ported from structur/CursorArtMatcher.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CursorArtMatcher
extends Node2D

var character: Character
var art_matcher
var cursor: CursorUnity
var last_sprite: Texture2D
var current_sprite: Texture2D
var output_sprite_holders: Dictionary
var character_outfits_array: Array
@export var target_sprite_game_object: Node2D
var follow_target: Sprite2D
var active: bool
var animal

func setup() -> void:  # C# Setup
	pass

func _process(delta: float) -> void:  # C# LateUpdate
	pass

func enable_1(show: bool) -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass
