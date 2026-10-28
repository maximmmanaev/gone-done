# Ported from structur/BeeSwarm.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name BeeSwarm
extends Node2D

var home_hive: Beehive
var target: Character
var caught: Dictionary
var characters: Array
var disappearing: bool
@export var placed_by_player_number: int
@export var kill_type: String

func _enter_tree() -> void:  # C# Awake
	pass

func release(target: Character) -> void:  # C# Release
	pass

func disappear() -> void:  # C# Disappear
	pass

func on_trigger_enter_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
