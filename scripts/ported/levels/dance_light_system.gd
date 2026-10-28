# Ported from structur/DanceLightSystem.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DanceLightSystem
extends Node2D

var dance_light_groups: Array
var current_dance_light_group: DanceLightGroup
var dance_lights: Array

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func start_new_light_sequence() -> void:  # C# StartNewLightSequence
	pass

func enter_build_mode() -> void:  # C# EnterBuildMode
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
