# Ported from structur/PunchingBlockAnimFeedback.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingBlockAnimFeedback
extends Node2D

var punching_block: PunchingBlock

func on_punch_anim_finished() -> void:  # C# OnPunchAnimFinished
	pass

func enable_hazard() -> void:  # C# EnableHazard
	pass

func disable_hazard() -> void:  # C# DisableHazard
	pass
