# Ported from structur/blackholeBurst.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name blackholeBurst
extends Node2D

var animator: AnimationPlayer
var sprite_renderer: Sprite2D
var target: Character
var parent_blackhole: Blackhole
var colors: Array
@export var stop_tracking: float
var follow_chr: bool

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func delete_me() -> void:  # C# DeleteMe
	pass
