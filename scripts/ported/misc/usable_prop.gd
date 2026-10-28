# Ported from structur/UsableProp.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name UsableProp
extends Node2D

enum LobbyType {
	ALL,
	LOCAL,
	ONLINE,
}
var in_use: bool
@export var sprite_renderer: Sprite2D
var high_light: bool
var hover_characters: Array
var show_in_lobby
var u_hidden: bool
var used_input_key
var m_event_mark_in_use
var character_using: Character
var event_mark_in_use  # C# property

func cmd_mark_in_use(in_use: bool) -> void:  # C# CmdMarkInUse
	pass

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func use(lobby_player, used_input_key) -> bool:  # C# Use
	return false

func release(un_freeze: bool) -> void:  # C# Release
	pass

func auth_set_used(in_use: bool) -> void:  # C# authSetUsed
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func tint() -> void:  # C# Tint
	pass

func u_show() -> void:  # C# show
	pass

func u_hide() -> void:  # C# hide
	pass
