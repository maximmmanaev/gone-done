# Ported from structur/GameControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GameControl
extends Node2D

enum GamePhase {
	NONE,
	START,
	PLAY,
	PLACE,
	SUDDENDEATH,
	END,
	WAIT,
}
var level_layout: Level
var graph_paper
var main_camera: ZoomCamera
@export var ui_camera: Camera2D
var fade_out
var inventory_book_prefab
var mods_display_controller_prefab
var pause_fade
var character_prefab: Character
var cursor_prefab: CursorUnity
var debug_character: Character
var debug_cursor: PiecePlacementCursor
var default_mode
var net_surrogate_prefab
var un_lock_box_prefab
@export var associated_scene: String
var start_phase
@export var start_delay: float
@export var win_time: float
@export var dance_time: float
var meta_list: PlaceableMetadataList
var inv_book_instance
var player_queue: Array
var placed_blocks: Array
var destroyed_blocks: Array
var active_blocks: Array
var attachments: Array
var msg_to_destroy_blocks: Dictionary
var winner: GamePlayer
var winner_set: bool
var start_delay_timer: float
var win_timer: float
var dance_timer: float
var first_play_frame: bool
var after_one_fixed_update: bool
var next_fixed_update: bool
var blocks_area: float
var level_density: float
var blocks_challenge: float
var average_block_challenge: float
var nonzero_average_challenge: float
var total_challenge: float
var challenge_blocks: int
var block_deaths: int
var suicide_deaths: int
var world_deaths: int
var winners: int
var lose_streak: int
var paused: bool
var soft_paused: bool
var scoreboard: bool
var holding_for_next_phase: bool
var next_phase
var move_up: bool
var move_down: bool
var round_number: int
var allow_respawn: bool
var unlock_number: int
var unlock_offset: int
var show_score_buttons: Array
var accept: bool
var back: bool
var inventory: bool
var u_pause: bool
var accept_up: bool
var back_up: bool
var inventory_up: bool
var pause_up: bool
var accept_down: bool
var back_down: bool
var inventory_down: bool
var pause_down: bool
var input_player_number: int
var paused_down_player: int
var debug_text_row: int
var waiting_for_players: bool
var snapshot_receive_buffer_idx: int
var snapshot_receive_buffer: Array
var player_numbers_still_loading_snapshot: Array
var deferred_network_surrogate_messages: Array
var orphaned_net_surrogates: Dictionary
var net_surrogates_to_remove_cache: Array
var scene_init_notification_sent: bool
var host_beacon_received: bool
var first_update_done: bool
var dead_session: bool
var clean_up_started: bool
var local_setup_start_done: bool
var post_setup_start: bool
var lives_display_controller
var debug_style
var kicks: int
var quits: int
var going_back_to_main_menu: bool
var pause_limiter: float
var pause_limit_timer: float
static var k_rpc_rpc_start_phase: int
static var k_rpc_rpc_play_music: int
static var k_rpc_rpc_start_fading_out: int
static var k_rpc_rpc_propagate_block_i_ds: int
static var k_rpc_rpc_set_up_compressed_snapshot_transfer: int
static var k_rpc_rpc_send_compressed_snapshot_chunk: int
static var k_rpc_rpc_load_compressed_snapshot: int
static var k_rpc_rpc_host_ready_beacon: int
static var k_rpc_rpc_do_initial_placement: int
var phase  # C# property
var inventory_book  # C# property
var current_player_queue: Array  # C# property
var match_guid  # C# property
var players_still_loading_snapshot: bool  # C# property
var network_associated_scene: String  # C# property
var networkunlock_offset: int  # C# property
var networkwaiting_for_players: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func initial_placement():  # C# initialPlacement (coroutine)
	pass

func get_hierarchy_depth(t: Node2D) -> int:  # C# GetHierarchyDepth
	return 0

func find_level_objects() -> void:  # C# findLevelObjects
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func try_flush_orphaned_net_surrogates() -> void:  # C# TryFlushOrphanedNetSurrogates
	pass

func send_client_analytics() -> void:  # C# sendClientAnalytics
	pass

func send_end_analytics() -> void:  # C# sendEndAnalytics
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func check_characters_above_minimum() -> void:  # C# CheckCharactersAboveMinimum
	pass

func reset_input() -> void:  # C# ResetInput
	pass

func setup_start(mode) -> void:  # C# SetupStart
	pass

func query_gamesparks_lobby():  # C# queryGamesparksLobby (coroutine)
	pass

func notify_scene_init_done() -> void:  # C# NotifySceneInitDone
	pass

func notify_setup_start_done() -> void:  # C# NotifySetupStartDone
	pass

func on_ready_to_start() -> void:  # C# OnReadyToStart
	pass

func process_next_unlocks() -> void:  # C# ProcessNextUnlocks
	pass

func to_place_mode_0() -> void:  # C# ToPlaceMode
	pass

func wait_for_phase_and_fade_out(target_phase):  # C# WaitForPhaseAndFadeOut (coroutine)
	pass

func wait_for_setup_start(run_after: Callable):  # C# WaitForSetupStart (coroutine)
	pass

func wait_for_post_setup_start(run_after: Callable):  # C# WaitForPostSetupStart (coroutine)
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass

func destroy_marked_pieces_now() -> void:  # C# DestroyMarkedPiecesNow
	pass

func destroy_marked_pieces() -> void:  # C# destroyMarkedPieces
	pass

func check_attachments() -> void:  # C# checkAttachments
	pass

func check_attachment_required_colliders() -> void:  # C# CheckAttachmentRequiredColliders
	pass

func after_a_fixed_update() -> void:  # C# AfterAFixedUpdate
	pass

func to_sudden_death() -> void:  # C# ToSuddenDeath
	pass

func setup_end() -> void:  # C# SetupEnd
	pass

func do_start() -> void:  # C# DoStart
	pass

func do_place_mode() -> void:  # C# DoPlaceMode
	pass

func do_play_mode() -> void:  # C# DoPlayMode
	pass

func do_sudden_death() -> void:  # C# DoSuddenDeath
	pass

func do_end() -> void:  # C# DoEnd
	pass

func show_scoreboard() -> void:  # C# ShowScoreboard
	pass

func after_score_board() -> void:  # C# AfterScoreBoard
	pass

func add_block(p: Placeable) -> void:  # C# AddBlock
	pass

func prepare_to_leave() -> void:  # C# PrepareToLeave
	pass

func end_game() -> void:  # C# EndGame
	pass

func back_to_main_menu(abort_reason: String) -> void:  # C# BackToMainMenu
	pass

func reset_turn_orders() -> void:  # C# resetTurnOrders
	pass

func fade_out_stay(level_scene_name: String):  # C# FadeOutStay (coroutine)
	pass

func fade_to_level(level: String, abort_reason: String):  # C# FadeToLevel (coroutine)
	pass

func fade_to_lobby() -> void:  # C# fadeToLobby
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func create_unlock_box(unlock_info) -> void:  # C# CreateUnlockBox
	pass

func wait_for_network_players():  # C# waitForNetworkPlayers (coroutine)
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func player_can_show_scoreboard(input_player_number: int) -> bool:  # C# PlayerCanShowScoreboard
	return false

func draw_debug_text_1(text: String) -> void:  # C# DrawDebugText
	pass

func draw_debug_text_3(text: String, color: Color, bg: Color) -> void:  # C# DrawDebugText
	pass

func draw_debug() -> void:  # C# DrawDebug
	pass

func rpc_start_phase(phase) -> void:  # C# RpcStartPhase
	pass

func rpc_play_music(music_name: String) -> void:  # C# RpcPlayMusic
	pass

func rpc_start_fading_out(to_main_menu: bool, level_scene_name: String) -> void:  # C# RpcStartFadingOut
	pass

func clean_up_scene_for_load() -> void:  # C# CleanUpSceneForLoad
	pass

func spawn_net_surrogate(spawn_for_block_id: int) -> void:  # C# SpawnNetSurrogate
	pass

func rpc_propagate_block_i_ds(paths: Array, i_ds: Array) -> void:  # C# RpcPropagateBlockIDs
	pass

func compress_and_send_snapshot_bytes(bytes: Array, on_all_clients_loaded_snapshot: Callable) -> void:  # C# CompressAndSendSnapshotBytes
	pass

func wait_for_all_clients_to_load_snapshot(on_all_clients_loaded_snapshot: Callable):  # C# WaitForAllClientsToLoadSnapshot (coroutine)
	pass

func rpc_set_up_compressed_snapshot_transfer(buffer_length: int) -> void:  # C# RpcSetUpCompressedSnapshotTransfer
	pass

func rpc_send_compressed_snapshot_chunk(buffer: Array) -> void:  # C# RpcSendCompressedSnapshotChunk
	pass

func rpc_load_compressed_snapshot(compressed_bytes: Array) -> void:  # C# RpcLoadCompressedSnapshot
	pass

func load_decompressed_snapshot_xml_document(doc) -> void:  # C# LoadDecompressedSnapshotXmlDocument
	pass

func rpc_host_ready_beacon() -> void:  # C# RpcHostReadyBeacon
	pass

func rpc_do_initial_placement() -> void:  # C# RpcDoInitialPlacement
	pass

func current_level_has_goal() -> bool:  # C# CurrentLevelHasGoal
	return false

func try_attach_placeables(pt: Placeable, parent: Placeable, attach: Placeable) -> void:  # C# TryAttachPlaceables
	pass

func do_attach_2(pt: Placeable, parent: Placeable) -> void:  # C# DoAttach
	pass

func do_attach_3(pt: Placeable, parent: Placeable, group: AttachmentGroup) -> void:  # C# DoAttach
	pass

func do_attach_4(pt: Placeable, parent: Placeable, pt_group: AttachmentGroup, parent_group: AttachmentGroup) -> void:  # C# DoAttach
	pass

func record_single_piece_stat(stat_name: String, piece: Placeable) -> bool:  # C# RecordSinglePieceStat
	return false

func increment_piece_stats(stat_name: String, p_0: Placeable, p_1: Placeable) -> void:  # C# IncrementPieceStats
	pass

func declare_session_dead() -> void:  # C# DeclareSessionDead
	pass

func check_null_and_destroy(mb: Node2D) -> void:  # C# CheckNullAndDestroy
	pass

func check_null_and_destroy_2(go: Node2D) -> void:  # C# CheckNullAndDestroy
	pass

static func log_current_mod_and_rule_info() -> void:  # C# LogCurrentModAndRuleInfo
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_rpc_rpc_start_phase(obj, reader) -> void:  # C# InvokeRpcRpcStartPhase
	pass

static func invoke_rpc_rpc_play_music(obj, reader) -> void:  # C# InvokeRpcRpcPlayMusic
	pass

static func invoke_rpc_rpc_start_fading_out(obj, reader) -> void:  # C# InvokeRpcRpcStartFadingOut
	pass

static func invoke_rpc_rpc_propagate_block_i_ds(obj, reader) -> void:  # C# InvokeRpcRpcPropagateBlockIDs
	pass

static func invoke_rpc_rpc_set_up_compressed_snapshot_transfer(obj, reader) -> void:  # C# InvokeRpcRpcSetUpCompressedSnapshotTransfer
	pass

static func invoke_rpc_rpc_send_compressed_snapshot_chunk(obj, reader) -> void:  # C# InvokeRpcRpcSendCompressedSnapshotChunk
	pass

static func invoke_rpc_rpc_load_compressed_snapshot(obj, reader) -> void:  # C# InvokeRpcRpcLoadCompressedSnapshot
	pass

static func invoke_rpc_rpc_host_ready_beacon(obj, reader) -> void:  # C# InvokeRpcRpcHostReadyBeacon
	pass

static func invoke_rpc_rpc_do_initial_placement(obj, reader) -> void:  # C# InvokeRpcRpcDoInitialPlacement
	pass

func call_rpc_start_phase(phase) -> void:  # C# CallRpcStartPhase
	pass

func call_rpc_play_music(music_name: String) -> void:  # C# CallRpcPlayMusic
	pass

func call_rpc_start_fading_out(to_main_menu: bool, level_scene_name: String) -> void:  # C# CallRpcStartFadingOut
	pass

func call_rpc_propagate_block_i_ds(paths: Array, i_ds: Array) -> void:  # C# CallRpcPropagateBlockIDs
	pass

func call_rpc_set_up_compressed_snapshot_transfer(buffer_length: int) -> void:  # C# CallRpcSetUpCompressedSnapshotTransfer
	pass

func call_rpc_send_compressed_snapshot_chunk(buffer: Array) -> void:  # C# CallRpcSendCompressedSnapshotChunk
	pass

func call_rpc_load_compressed_snapshot(compressed_bytes: Array) -> void:  # C# CallRpcLoadCompressedSnapshot
	pass

func call_rpc_host_ready_beacon() -> void:  # C# CallRpcHostReadyBeacon
	pass

func call_rpc_do_initial_placement() -> void:  # C# CallRpcDoInitialPlacement
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
