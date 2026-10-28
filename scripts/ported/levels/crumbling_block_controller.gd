# Ported from structur/CrumblingBlockController.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CrumblingBlockController
extends Node2D

var level_blocks: Array

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func reset_crumbling_blocks() -> void:  # C# ResetCrumblingBlocks
	pass

func add_all_crumbling_blocks_in_scene() -> void:  # C# AddAllCrumblingBlocksInScene
	pass
