# Ported from structur/PunchingBlockProjectileTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingBlockProjectileTrigger
extends Node2D

var punching_block: PunchingBlock
var punching_block_trigger: PunchingBlockTrigger

func on_trigger_enter_2d(collider: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
