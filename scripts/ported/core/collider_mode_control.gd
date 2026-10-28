# Ported from structur/ColliderModeControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ColliderModeControl
extends Node2D

@export var placement_phase: bool
@export var placed_phase: bool
@export var run_phase: bool
@export var always_on_in_versus: bool
var current_phase: int

func _enter_tree() -> void:  # C# Awake
	pass

func switch_to_mode(new_phase: int, force_update: bool) -> void:  # C# SwitchToMode
	pass

func switch(on_off: bool) -> void:  # C# Switch
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass
