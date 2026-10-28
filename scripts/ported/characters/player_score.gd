# Ported from structur/PlayerScore.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PlayerScore
extends Node2D

var checkbox_prefab
@export var max_score: int
var checkboxes: Array
@export var spacing: float
@export var icon: Sprite2D
@export var u_name: Sprite2D
var score: int

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func set_max_score(max_score: int) -> void:  # C# SetMaxScore
	pass

func increment_score(amount: int) -> void:  # C# IncrementScore
	pass

func set_score(score: int) -> void:  # C# SetScore
	pass

func get_score() -> int:  # C# GetScore
	return 0

func show_0() -> void:  # C# Show
	pass

func hide_0() -> void:  # C# Hide
	pass
