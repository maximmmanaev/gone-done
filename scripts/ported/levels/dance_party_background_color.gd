# Ported from structur/DancePartyBackgroundColor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DancePartyBackgroundColor
extends Node2D

@export var target_sprite: Sprite2D
var animator: AnimationPlayer
@export var blend_tree_state_count: int

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
