# Ported from structur/CreateGameControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CreateGameControl
extends Node2D

var game_mode_prefabs: Array
var level_layout: Level
var graph_paper

func _enter_tree() -> void:  # C# Awake
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
