# Ported from structur/PartyModeToggle.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyModeToggle
extends Node2D

@export var disco_ball_animator: AnimationPlayer
var party_button
@export var text_flipper: AnimationPlayer
var text_changer
var cs: Array
var ls: Array
var flashing_arrow_animators: Array
var themes: Array
@export var change_speed_multiplier: float
var last_audio_mode

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func change_modes(to_mode) -> void:  # C# changeModes
	pass

func change_colours(to_mode):  # C# ChangeColours (coroutine)
	pass

func copy_initial_colors() -> void:  # C# CopyInitialColors
	pass

func force_lighting(to_mode) -> void:  # C# ForceLighting
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
