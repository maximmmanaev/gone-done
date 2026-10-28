# Ported from structur/CoveringLevelPart.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CoveringLevelPart
extends Node2D

var bottom_sprite: Sprite2D
var top_sprite: Sprite2D
@export var free_play_only: bool

func _enter_tree() -> void:  # C# Awake
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func fade_top_sprite(alpha_0: float, alpha_1: float, duration: float):  # C# FadeTopSprite (coroutine)
	pass
