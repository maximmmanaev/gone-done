# Ported from structur/RaftLevelLogic.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RaftLevelLogic
extends Node2D

static var high_tide: int
var kraken_trigger: KrakenTrigger
var is_first_play_time: bool
var animator: AnimationPlayer

func _enter_tree() -> void:  # C# Awake
	pass

func on_enable() -> void:  # C# OnEnable
	pass

func on_disable() -> void:  # C# OnDisable
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
