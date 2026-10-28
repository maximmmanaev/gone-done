# Ported from structur/StartGameState.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name StartGameState
extends Node2D

var waiting_for: int
@export var load_main_menu: bool

func _enter_tree() -> void:  # C# Awake
	pass

func update_localization_async():  # C# UpdateLocalizationAsync
	pass

func _process(delta: float) -> void:  # C# Update
	pass
