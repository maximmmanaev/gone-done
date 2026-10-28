# Ported from structur/VersusControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name VersusControl
extends GameControl

var graph_score_board_prefab
var ready_message_prefab
var sudden_death_message_prefab
var placement_ending_message_prefab
var win_message_prefab
var party_box_prefab: PartyBox
var digital_clock_prefab
var last_turn_prefab
var scorecard_message_prefab
var suicide_note_prefab: SuicideNote
@export var show_score_time: float
@export var wait_time: float
@export var max_run_time: float
@export var max_level_time: float
@export var turn_message_time: float
@export var block_difficulty_weight: float
@export var death_difficulty_weight: float
@export var block_difficuly_multiplier: float
@export var death_difficulty_multiplier: float
@export var max_lose_streak: int
var force_start_hazard: BlockGroup
@export var start_hazard_prop: float
var force_teleporter: BlockGroup
@export var force_teleporter_prop: float
var force_honey: BlockGroup
@export var force_honey_prop: float
var score_timer: float
var ready_timer: float
var level_timer: float
var countdown_timer: float
var turn_message_timer: float
var placement_timer: float
@export var display_scoreboard: bool
var scoreboard_cooldown: float
var scoreboard_held: float
var showing_placement_warning: bool
var pieces_removed: bool
var next_to_build: int
var last_to_build: int
var award_points: bool
var last_rounds_mode: bool
var last_rounds_to_go: int
var last_rounds_timer: bool
var last_rounds_time_limit: float
var last_rounds_place_time: float
var min_last_rounds_run_time: float
var is_second_box: bool
var spectator_vertical_offset: float
var graph_score_board_instance
var ready_message_instance
var sudden_death_message_instance
var placement_ending_message_instance
var win_message_instance
var party_box_instance: PartyBox
var digital_clock_instance
var last_turn_instance
var scorecard_message_instance
var suicide_note_instance: SuicideNote
var scorekeeper_instance: ScoreKeeper
var run_timer: RunTimer
var starting_blocks: int
var max_block_at_start: int
var run_time: float
var fastest_time: float
var win_order: Array
var winner_queue: Array
var last_winner: int
var run_started: bool
var place_started: bool
var remaining_placements: Array
var remaining_party_boxes: int
var placed_this_round: Array
@export var objects_holding_up_place_phase: int
var waiting_for_characters: bool
var skip_turn_message: bool
var random_start_position_string: String
var game_intensity_level: float
var curren_target_difficulty: float
var changing_to_play_phase: bool
@export var force_place_phase_continue_time: float
var force_place_phase_continue_timer: float
var forced_piece_spawns: Array
@export var debug_party_box: bool
var partybox_debug_info: Array
var was_showing_score: bool
var delay_rpc_select_random
var agony_time_limit_timer: float
var agonoy_timer_limit_triggered: bool
var agony_final_count_down_started: bool
static var k_rpc_rpc_setup_placement_cursors: int
static var k_rpc_rpc_show_scorecard_message: int
static var k_rpc_rpc_increment_character_success: int
static var k_rpc_rpc_increment_character_wins: int
static var k_rpc_rpc_back_to_basic_achievement: int
static var k_rpc_rpc_show_last_turn_message: int
static var k_rpc_rpc_hide_last_turn_message: int
static var k_rpc_rpc_show_scoreboard: int
static var k_rpc_rpc_show_placement_warning: int
static var k_rpc_rpc_send_placement_timer_done: int
static var k_rpc_rpc_remove_unplaced_objects: int
static var k_rpc_rpc_set_countdown: int
static var k_rpc_rpc_set_winner: int
static var k_rpc_rpc_show_party_box: int
static var k_rpc_rpc_force_select_random_blocks: int
static var k_rpc_rpc_force_spawn_piece: int
static var k_rpc_rpc_force_spawn_variant_piece: int
static var k_rpc_rpc_run_timer_hit: int
static var k_rpc_rpc_trigger_agony_run_timer: int
var players_left_to_place: bool  # C# property
var max_score: int  # C# property
var current_winning_score: int  # C# property
var scores: Array  # C# property
var party_box: PartyBox  # C# property
var party_box_still_active: bool  # C# property
var networkwaiting_for_characters: bool  # C# property
var networkskip_turn_message: bool  # C# property
var network_random_start_position_string: String  # C# property

func get_rank(network_number: int) -> int:  # C# GetRank
	return 0

func _ready() -> void:  # C# Start
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func setup_start(mode) -> void:  # C# SetupStart
	pass

func on_finish_setup_start() -> void:  # C# OnFinishSetupStart
	pass

func to_place_mode_0() -> void:  # C# ToPlaceMode
	pass

func force_select_random_blocks() -> void:  # C# ForceSelectRandomBlocks
	pass

func on_forced_piece_spawned(network_number: int) -> void:  # C# OnForcedPieceSpawned
	pass

func host_wait_to_setup_placement_cursors():  # C# HostWaitToSetupPlacementCursors (coroutine)
	pass

func rpc_setup_placement_cursors(wait_for_forced_pieces: bool) -> void:  # C# RpcSetupPlacementCursors
	pass

func wait_for_forced_pieces_and_setup_cursors():  # C# WaitForForcedPiecesAndSetupCursors (coroutine)
	pass

func show_party_box() -> void:  # C# showPartyBox
	pass

func setup_party_box_for_round(do_choose_pieces: bool) -> void:  # C# SetupPartyBoxForRound
	pass

func shuffle_start_position() -> void:  # C# ShuffleStartPosition
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass

func to_sudden_death() -> void:  # C# ToSuddenDeath
	pass

func to_timed_sudden_death() -> void:  # C# ToTimedSuddenDeath
	pass

func do_start() -> void:  # C# DoStart
	pass

func wait_for_pre_game_events(on_finish: Callable):  # C# WaitForPreGameEvents (coroutine)
	pass

func are_all_pieces_ready() -> bool:  # C# AreAllPiecesReady
	return false

func do_place_mode() -> void:  # C# DoPlaceMode
	pass

func change_to_play_phase_delayed():  # C# ChangeToPlayPhaseDelayed (coroutine)
	pass

func do_play_mode() -> void:  # C# DoPlayMode
	pass

func do_sudden_death() -> void:  # C# DoSuddenDeath
	pass

func reset_player_character_1(c: Character) -> void:  # C# resetPlayerCharacter
	pass

func do_timed_sudden_death() -> void:  # C# DoTimedSuddenDeath
	pass

func send_end_analytics() -> void:  # C# sendEndAnalytics
	pass

func setup_end() -> void:  # C# SetupEnd
	pass

func do_end() -> void:  # C# DoEnd
	pass

func wait_for_winner_set():  # C# waitForWinnerSet (coroutine)
	pass

func choose_post_play_phase() -> void:  # C# ChoosePostPlayPhase
	pass

func show_scoreboard() -> void:  # C# ShowScoreboard
	pass

func after_score_board() -> void:  # C# AfterScoreBoard
	pass

func after_score_board_coroutine():  # C# AfterScoreBoardCoroutine (coroutine)
	pass

func wait_for_characters():  # C# waitForCharacters (coroutine)
	pass

func draw_debug() -> void:  # C# DrawDebug
	pass

func reset_turn_orders() -> void:  # C# resetTurnOrders
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func setup_placement_cursors() -> void:  # C# SetupPlacementCursors
	pass

func on_remaining_placements_changed(player_number: int) -> void:  # C# OnRemainingPlacementsChanged
	pass

func rpc_show_scorecard_message(all_win: bool, no_win: bool, any_points: bool, coin_points: bool, race_points: bool) -> void:  # C# RpcShowScorecardMessage
	pass

func rpc_increment_character_success(character_sprite_number: int) -> void:  # C# RpcIncrementCharacterSuccess
	pass

func rpc_increment_character_wins(character_sprite_number: int) -> void:  # C# RpcIncrementCharacterWins
	pass

func rpc_back_to_basic_achievement(network_number: int) -> void:  # C# RpcBackToBasicAchievement
	pass

func rpc_show_last_turn_message(number_remaining: int) -> void:  # C# RpcShowLastTurnMessage
	pass

func rpc_hide_last_turn_message() -> void:  # C# RpcHideLastTurnMessage
	pass

func rpc_show_scoreboard(show_score_time: float, check_streaks: bool, clear_points: bool) -> void:  # C# RpcShowScoreboard
	pass

func rpc_show_placement_warning(time: float, show_text: bool) -> void:  # C# RpcShowPlacementWarning
	pass

func rpc_send_placement_timer_done() -> void:  # C# RpcSendPlacementTimerDone
	pass

func rpc_remove_unplaced_objects() -> void:  # C# RpcRemoveUnplacedObjects
	pass

func rpc_set_countdown(time: float) -> void:  # C# RpcSetCountdown
	pass

func rpc_set_winner(winner: Node2D) -> void:  # C# RpcSetWinner
	pass

func rpc_show_party_box() -> void:  # C# RpcShowPartyBox
	pass

func delay_rpc_force_select_random_blocks():  # C# DelayRpcForceSelectRandomBlocks (coroutine)
	pass

func rpc_force_select_random_blocks() -> void:  # C# RpcForceSelectRandomBlocks
	pass

func signal_forced_piece_spawned(network_number: int) -> void:  # C# SignalForcedPieceSpawned
	pass

func rpc_force_spawn_piece(network_number: int, pickable_index: int, is_twitch_item: bool) -> void:  # C# RpcForceSpawnPiece
	pass

func rpc_force_spawn_variant_piece(network_number: int, base_pickable_index: int, variant_index: int, is_twitch_item: bool) -> void:  # C# RpcForceSpawnVariantPiece
	pass

func on_run_timer_limit_reached() -> void:  # C# OnRunTimerLimitReached
	pass

func rpc_run_timer_hit() -> void:  # C# RpcRunTimerHit
	pass

func clean_up_scene_for_load() -> void:  # C# CleanUpSceneForLoad
	pass

func check_agony_time_limit() -> void:  # C# CheckAgonyTimeLimit
	pass

func rpc_trigger_agony_run_timer(time: float) -> void:  # C# RpcTriggerAgonyRunTimer
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_rpc_rpc_setup_placement_cursors(obj, reader) -> void:  # C# InvokeRpcRpcSetupPlacementCursors
	pass

static func invoke_rpc_rpc_show_scorecard_message(obj, reader) -> void:  # C# InvokeRpcRpcShowScorecardMessage
	pass

static func invoke_rpc_rpc_increment_character_success(obj, reader) -> void:  # C# InvokeRpcRpcIncrementCharacterSuccess
	pass

static func invoke_rpc_rpc_increment_character_wins(obj, reader) -> void:  # C# InvokeRpcRpcIncrementCharacterWins
	pass

static func invoke_rpc_rpc_back_to_basic_achievement(obj, reader) -> void:  # C# InvokeRpcRpcBackToBasicAchievement
	pass

static func invoke_rpc_rpc_show_last_turn_message(obj, reader) -> void:  # C# InvokeRpcRpcShowLastTurnMessage
	pass

static func invoke_rpc_rpc_hide_last_turn_message(obj, reader) -> void:  # C# InvokeRpcRpcHideLastTurnMessage
	pass

static func invoke_rpc_rpc_show_scoreboard(obj, reader) -> void:  # C# InvokeRpcRpcShowScoreboard
	pass

static func invoke_rpc_rpc_show_placement_warning(obj, reader) -> void:  # C# InvokeRpcRpcShowPlacementWarning
	pass

static func invoke_rpc_rpc_send_placement_timer_done(obj, reader) -> void:  # C# InvokeRpcRpcSendPlacementTimerDone
	pass

static func invoke_rpc_rpc_remove_unplaced_objects(obj, reader) -> void:  # C# InvokeRpcRpcRemoveUnplacedObjects
	pass

static func invoke_rpc_rpc_set_countdown(obj, reader) -> void:  # C# InvokeRpcRpcSetCountdown
	pass

static func invoke_rpc_rpc_set_winner(obj, reader) -> void:  # C# InvokeRpcRpcSetWinner
	pass

static func invoke_rpc_rpc_show_party_box(obj, reader) -> void:  # C# InvokeRpcRpcShowPartyBox
	pass

static func invoke_rpc_rpc_force_select_random_blocks(obj, reader) -> void:  # C# InvokeRpcRpcForceSelectRandomBlocks
	pass

static func invoke_rpc_rpc_force_spawn_piece(obj, reader) -> void:  # C# InvokeRpcRpcForceSpawnPiece
	pass

static func invoke_rpc_rpc_force_spawn_variant_piece(obj, reader) -> void:  # C# InvokeRpcRpcForceSpawnVariantPiece
	pass

static func invoke_rpc_rpc_run_timer_hit(obj, reader) -> void:  # C# InvokeRpcRpcRunTimerHit
	pass

static func invoke_rpc_rpc_trigger_agony_run_timer(obj, reader) -> void:  # C# InvokeRpcRpcTriggerAgonyRunTimer
	pass

func call_rpc_setup_placement_cursors(wait_for_forced_pieces: bool) -> void:  # C# CallRpcSetupPlacementCursors
	pass

func call_rpc_show_scorecard_message(all_win: bool, no_win: bool, any_points: bool, coin_points: bool, race_points: bool) -> void:  # C# CallRpcShowScorecardMessage
	pass

func call_rpc_increment_character_success(character_sprite_number: int) -> void:  # C# CallRpcIncrementCharacterSuccess
	pass

func call_rpc_increment_character_wins(character_sprite_number: int) -> void:  # C# CallRpcIncrementCharacterWins
	pass

func call_rpc_back_to_basic_achievement(network_number: int) -> void:  # C# CallRpcBackToBasicAchievement
	pass

func call_rpc_show_last_turn_message(number_remaining: int) -> void:  # C# CallRpcShowLastTurnMessage
	pass

func call_rpc_hide_last_turn_message() -> void:  # C# CallRpcHideLastTurnMessage
	pass

func call_rpc_show_scoreboard(show_score_time: float, check_streaks: bool, clear_points: bool) -> void:  # C# CallRpcShowScoreboard
	pass

func call_rpc_show_placement_warning(time: float, show_text: bool) -> void:  # C# CallRpcShowPlacementWarning
	pass

func call_rpc_send_placement_timer_done() -> void:  # C# CallRpcSendPlacementTimerDone
	pass

func call_rpc_remove_unplaced_objects() -> void:  # C# CallRpcRemoveUnplacedObjects
	pass

func call_rpc_set_countdown(time: float) -> void:  # C# CallRpcSetCountdown
	pass

func call_rpc_set_winner(winner: Node2D) -> void:  # C# CallRpcSetWinner
	pass

func call_rpc_show_party_box() -> void:  # C# CallRpcShowPartyBox
	pass

func call_rpc_force_select_random_blocks() -> void:  # C# CallRpcForceSelectRandomBlocks
	pass

func call_rpc_force_spawn_piece(network_number: int, pickable_index: int, is_twitch_item: bool) -> void:  # C# CallRpcForceSpawnPiece
	pass

func call_rpc_force_spawn_variant_piece(network_number: int, base_pickable_index: int, variant_index: int, is_twitch_item: bool) -> void:  # C# CallRpcForceSpawnVariantPiece
	pass

func call_rpc_run_timer_hit() -> void:  # C# CallRpcRunTimerHit
	pass

func call_rpc_trigger_agony_run_timer(time: float) -> void:  # C# CallRpcTriggerAgonyRunTimer
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
