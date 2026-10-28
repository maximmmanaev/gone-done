# Ported from structur/PunchingBlockTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingBlockTrigger
extends Node2D

var punching_block: PunchingBlock
@export var trigger_animator: AnimationPlayer
var last_num_characters: int
var triggered_by_client: float
var animator_on: bool
var character_colliders: Array
var recently_triggered_by_client: bool  # C# property
var triggered_by_local_player: bool  # C# property

func set_pushed(pushed: bool) -> void:  # C# SetPushed
	pass

func on_trigger_enter_2d(collider: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_exit_2d(collider: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_client_touched_trigger() -> void:  # C# OnClientTouchedTrigger
	pass
