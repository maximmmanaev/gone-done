# Ported from structur/Spectator.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Spectator
extends Node2D

enum SpectatorState {
	IDLE,
	VICTORY,
	DYING,
	DEAD,
}
var anim: AnimationPlayer
var sprite_r: Sprite2D
var state
var sprite_render: Sprite2D  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func get_state():  # C# GetState
	pass

func set_state(state) -> void:  # C# SetState
	pass

func show_0() -> void:  # C# Show
	pass

func hide_0() -> void:  # C# Hide
	pass
