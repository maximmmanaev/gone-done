# Ported from structur/GamePlayer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GamePlayer
extends Node2D

var cursor_prefab
var character_prefab: Character
var character_net_id
var cursor_net_id
var cursor_instance: CursorUnity
var party_pick_cursor: PartyPickCursor
var character_instance: Character
var local_player: PlayerUnity
var control: Controller
@export var was_kicked: bool
@export var network_number: int
@export var local_number: int
var picked_animal
@export var player_name: String
var character_outfits_list
@export var player_color: Color
var in_phase
@export var handicap: int
@export var turn_order: int
@export var scene_init_done: bool
@export var setup_start_done: bool
@export var initialized: bool
var initialized_by_local_player: bool
@export var lives: int
var current_free_play_phase
static var k_listcharacter_outfits_list: int
static var k_cmd_cmd_set_in_phase: int
static var k_cmd_cmd_set_player_number: int
static var k_cmd_cmd_assign_cursor: int
static var k_rpc_rpc_assign_cursor: int
static var k_cmd_cmd_remove_cursor: int
static var k_rpc_rpc_remove_cursor: int
static var k_cmd_cmd_assign_character: int
static var k_rpc_rpc_assign_character: int
static var k_cmd_cmd_set_player_name: int
static var k_cmd_cmd_set_player_handicap: int
static var k_cmd_cmd_set_scene_init_done: int
static var k_cmd_cmd_setup_start_done: int
static var k_cmd_cmd_set_initialized_by_local_player: int
static var k_cmd_cmd_set_current_free_play_phase: int
static var k_cmd_cmd_remove_player: int
static var k_rpc_rpc_remove_player: int
static var k_rpc_rpc_kill_player: int
var magical_unity_event_happened: bool  # C# property
var is_local_player: bool  # C# property
var is_wearing_skin: bool  # C# property
var networkcharacter_net_id  # C# property
var networkcursor_net_id  # C# property
var networknetwork_number: int  # C# property
var networklocal_number: int  # C# property
var network_picked_animal  # C# property
var networkplayer_name: String  # C# property
var network_player_color: Color  # C# property
var network_in_phase  # C# property
var network_handicap: int  # C# property
var network_initialized_by_local_player: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func init_player():  # C# InitPlayer (coroutine)
	pass

func set_in_phase(phase) -> void:  # C# SetInPhase
	pass

func cmd_set_in_phase(phase) -> void:  # C# CmdSetInPhase
	pass

func cmd_set_player_number(number: int) -> void:  # C# CmdSetPlayerNumber
	pass

func cmd_assign_cursor(cursor_obj: Node2D, network_number: int, local_number: int) -> void:  # C# CmdAssignCursor
	pass

func rpc_assign_cursor(go: Node2D, network_number: int, local_number: int) -> void:  # C# RpcAssignCursor
	pass

func cmd_remove_cursor() -> void:  # C# CmdRemoveCursor
	pass

func rpc_remove_cursor(network_number: int) -> void:  # C# RpcRemoveCursor
	pass

func cmd_assign_character(char_obj: Node2D, network_number: int, local_number: int) -> void:  # C# CmdAssignCharacter
	pass

func rpc_assign_character(go: Node2D, network_number: int, local_number: int) -> void:  # C# RpcAssignCharacter
	pass

func cmd_set_player_name(new_player_name: String) -> void:  # C# CmdSetPlayerName
	pass

func cmd_set_player_handicap(new_handicap: int) -> void:  # C# CmdSetPlayerHandicap
	pass

func cmd_set_scene_init_done(done: bool) -> void:  # C# CmdSetSceneInitDone
	pass

func cmd_setup_start_done() -> void:  # C# CmdSetupStartDone
	pass

func cmd_set_initialized_by_local_player() -> void:  # C# CmdSetInitializedByLocalPlayer
	pass

func run_after_initialized(on_condition_met: Callable) -> void:  # C# RunAfterInitialized
	pass

func cmd_set_current_free_play_phase(phase) -> void:  # C# CmdSetCurrentFreePlayPhase
	pass

func remove_player_0() -> void:  # C# RemovePlayer
	pass

func cmd_remove_player() -> void:  # C# CmdRemovePlayer
	pass

func rpc_remove_player() -> void:  # C# RpcRemovePlayer
	pass

func rpc_kill_player(death_cause: String) -> void:  # C# RpcKillPlayer
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_sync_listcharacter_outfits_list(obj, reader) -> void:  # C# InvokeSyncListcharacterOutfitsList
	pass

static func invoke_cmd_cmd_set_in_phase(obj, reader) -> void:  # C# InvokeCmdCmdSetInPhase
	pass

static func invoke_cmd_cmd_set_player_number(obj, reader) -> void:  # C# InvokeCmdCmdSetPlayerNumber
	pass

static func invoke_cmd_cmd_assign_cursor(obj, reader) -> void:  # C# InvokeCmdCmdAssignCursor
	pass

static func invoke_cmd_cmd_remove_cursor(obj, reader) -> void:  # C# InvokeCmdCmdRemoveCursor
	pass

static func invoke_cmd_cmd_assign_character(obj, reader) -> void:  # C# InvokeCmdCmdAssignCharacter
	pass

static func invoke_cmd_cmd_set_player_name(obj, reader) -> void:  # C# InvokeCmdCmdSetPlayerName
	pass

static func invoke_cmd_cmd_set_player_handicap(obj, reader) -> void:  # C# InvokeCmdCmdSetPlayerHandicap
	pass

static func invoke_cmd_cmd_set_scene_init_done(obj, reader) -> void:  # C# InvokeCmdCmdSetSceneInitDone
	pass

static func invoke_cmd_cmd_setup_start_done(obj, reader) -> void:  # C# InvokeCmdCmdSetupStartDone
	pass

static func invoke_cmd_cmd_set_initialized_by_local_player(obj, reader) -> void:  # C# InvokeCmdCmdSetInitializedByLocalPlayer
	pass

static func invoke_cmd_cmd_set_current_free_play_phase(obj, reader) -> void:  # C# InvokeCmdCmdSetCurrentFreePlayPhase
	pass

static func invoke_cmd_cmd_remove_player(obj, reader) -> void:  # C# InvokeCmdCmdRemovePlayer
	pass

func call_cmd_set_in_phase(phase) -> void:  # C# CallCmdSetInPhase
	pass

func call_cmd_set_player_number(number: int) -> void:  # C# CallCmdSetPlayerNumber
	pass

func call_cmd_assign_cursor(cursor_obj: Node2D, network_number: int, local_number: int) -> void:  # C# CallCmdAssignCursor
	pass

func call_cmd_remove_cursor() -> void:  # C# CallCmdRemoveCursor
	pass

func call_cmd_assign_character(char_obj: Node2D, network_number: int, local_number: int) -> void:  # C# CallCmdAssignCharacter
	pass

func call_cmd_set_player_name(new_player_name: String) -> void:  # C# CallCmdSetPlayerName
	pass

func call_cmd_set_player_handicap(new_handicap: int) -> void:  # C# CallCmdSetPlayerHandicap
	pass

func call_cmd_set_scene_init_done(done: bool) -> void:  # C# CallCmdSetSceneInitDone
	pass

func call_cmd_setup_start_done() -> void:  # C# CallCmdSetupStartDone
	pass

func call_cmd_set_initialized_by_local_player() -> void:  # C# CallCmdSetInitializedByLocalPlayer
	pass

func call_cmd_set_current_free_play_phase(phase) -> void:  # C# CallCmdSetCurrentFreePlayPhase
	pass

func call_cmd_remove_player() -> void:  # C# CallCmdRemovePlayer
	pass

static func invoke_rpc_rpc_assign_cursor(obj, reader) -> void:  # C# InvokeRpcRpcAssignCursor
	pass

static func invoke_rpc_rpc_remove_cursor(obj, reader) -> void:  # C# InvokeRpcRpcRemoveCursor
	pass

static func invoke_rpc_rpc_assign_character(obj, reader) -> void:  # C# InvokeRpcRpcAssignCharacter
	pass

static func invoke_rpc_rpc_remove_player(obj, reader) -> void:  # C# InvokeRpcRpcRemovePlayer
	pass

static func invoke_rpc_rpc_kill_player(obj, reader) -> void:  # C# InvokeRpcRpcKillPlayer
	pass

func call_rpc_assign_cursor(go: Node2D, network_number: int, local_number: int) -> void:  # C# CallRpcAssignCursor
	pass

func call_rpc_remove_cursor(network_number: int) -> void:  # C# CallRpcRemoveCursor
	pass

func call_rpc_assign_character(go: Node2D, network_number: int, local_number: int) -> void:  # C# CallRpcAssignCharacter
	pass

func call_rpc_remove_player() -> void:  # C# CallRpcRemovePlayer
	pass

func call_rpc_kill_player(death_cause: String) -> void:  # C# CallRpcKillPlayer
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
