# Ported from structur/PartyPickCursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyPickCursor
extends PickCursor

@export var spawned_on_client: bool
static var k_cmd_cmd_set_spawned: int
var network_spawned_on_client: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func on_rotate_left() -> void:  # C# OnRotateLeft
	pass

func on_rotate_right() -> void:  # C# OnRotateRight
	pass

func on_back() -> void:  # C# OnBack
	pass

func on_inventory() -> void:  # C# OnInventory
	pass

func on_accept_0() -> void:  # C# OnAccept
	pass

func try_pick_piece():  # C# tryPickPiece (coroutine)
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func cmd_set_spawned(is_spawned: bool) -> void:  # C# CmdSetSpawned
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_set_spawned(obj, reader) -> void:  # C# InvokeCmdCmdSetSpawned
	pass

func call_cmd_set_spawned(is_spawned: bool) -> void:  # C# CallCmdSetSpawned
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
