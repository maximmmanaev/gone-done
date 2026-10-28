# Ported from structur/AnimationElement.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AnimationElement
extends Node2D

@export var anim_name: String
var animator: AnimationPlayer
var sprite: Sprite2D

func _enter_tree() -> void:  # C# Awake
	pass

func on_enable() -> void:  # C# OnEnable
	pass

func on_disable() -> void:  # C# OnDisable
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func start_playing() -> void:  # C# StartPlaying
	pass

func stop_playing() -> void:  # C# StopPlaying
	pass
