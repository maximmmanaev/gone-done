# Ported from structur/ChallengeControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ChallengeControl
extends GameControl

@export var camera_reset_speed: float
@export var camera_reset_zoom_speed: float
@export var online_countdown_time: int
@export var host_resync_interval: float
@export var single_player_delay_time: float
var digital_clock_prefab
var ready_message_prefab
var scoreboard_prefab
var count_down_start_prefab
var status_display_prefab
var coin_display_prefab: CoinStatusDisplay
var retry_message_prefab: SuicideNote
var digital_clock_instance
var ready_message_instance
var scoreboard_instance
var count_down_start_instance
var status_display_instance
var coin_display_instance: CoinStatusDisplay
var retry_message_instance: SuicideNote
var waiting_for_characters: bool
var run_time: float
var cumulative_time: float
var run_started: bool
var counting_down: bool
var run_failed: bool
var last_resync: float
@export var fail_color: Color
var dying_characters: Array
var attachments_checked_once: bool
var place_mode_delay: float
var ever_succeeded: bool
var player_end_times: Dictionary
var player_die_times: Dictionary
static var k_rpc_rpc_show_scoreboard: int
static var k_rpc_rpc_hide_scoreboard: int
static var k_rpc_rpc_trigger_retry: int
static var k_rpc_rpc_pass_leaderboard_data: int
static var k_rpc_rpc_trigger_start_countdown: int
static var k_rpc_rpc_set_slot_status: int
static var k_rpc_rpc_resync_run_time: int
var is_book_shown: bool  # C# property

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func setup_start(mode) -> void:  # C# SetupStart
	pass

func to_place_mode_0() -> void:  # C# ToPlaceMode
	pass

func after_a_fixed_update() -> void:  # C# AfterAFixedUpdate
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass

func do_start() -> void:  # C# DoStart
	pass

func do_place_mode() -> void:  # C# DoPlaceMode
	pass

func do_play_mode() -> void:  # C# DoPlayMode
	pass

func after_score_board() -> void:  # C# AfterScoreBoard
	pass

func send_end_analytics() -> void:  # C# sendEndAnalytics
	pass

func wait_for_characters():  # C# waitForCharacters (coroutine)
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func zoom_in() -> void:  # C# zoomIn
	pass

func zoom_out() -> void:  # C# zoomOut
	pass

func rpc_show_scoreboard(round_time: float, sum_of_times: float, success: bool) -> void:  # C# RpcShowScoreboard
	pass

func rpc_hide_scoreboard() -> void:  # C# RpcHideScoreboard
	pass

func rpc_trigger_retry() -> void:  # C# RpcTriggerRetry
	pass

func rpc_pass_leaderboard_data(no_coins_list_json: String, all_coins_list_json: String, metadata_json: String) -> void:  # C# RpcPassLeaderboardData
	pass

func rpc_trigger_start_countdown(countdown_time: int) -> void:  # C# RpcTriggerStartCountdown
	pass

func trigger_single_player_start() -> void:  # C# TriggerSinglePlayerStart
	pass

func wait_for_single_player_start(delay: float):  # C# waitForSinglePlayerStart (coroutine)
	pass

func wait_for_countdown(countdown_time: int, buffer: float):  # C# waitForCountdown (coroutine)
	pass

func rpc_set_slot_status(player_network_number: int, new_state) -> void:  # C# RpcSetSlotStatus
	pass

func rpc_resync_run_time(host_run_time: float) -> void:  # C# RpcResyncRunTime
	pass

func start_run(single_player: bool) -> void:  # C# startRun
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func notify_challenge_attempt(success: bool, seconds_in_level: int) -> void:  # C# NotifyChallengeAttempt
	pass

func clean_up_scene_for_load() -> void:  # C# CleanUpSceneForLoad
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_rpc_rpc_show_scoreboard(obj, reader) -> void:  # C# InvokeRpcRpcShowScoreboard
	pass

static func invoke_rpc_rpc_hide_scoreboard(obj, reader) -> void:  # C# InvokeRpcRpcHideScoreboard
	pass

static func invoke_rpc_rpc_trigger_retry(obj, reader) -> void:  # C# InvokeRpcRpcTriggerRetry
	pass

static func invoke_rpc_rpc_pass_leaderboard_data(obj, reader) -> void:  # C# InvokeRpcRpcPassLeaderboardData
	pass

static func invoke_rpc_rpc_trigger_start_countdown(obj, reader) -> void:  # C# InvokeRpcRpcTriggerStartCountdown
	pass

static func invoke_rpc_rpc_set_slot_status(obj, reader) -> void:  # C# InvokeRpcRpcSetSlotStatus
	pass

static func invoke_rpc_rpc_resync_run_time(obj, reader) -> void:  # C# InvokeRpcRpcResyncRunTime
	pass

func call_rpc_show_scoreboard(round_time: float, sum_of_times: float, success: bool) -> void:  # C# CallRpcShowScoreboard
	pass

func call_rpc_hide_scoreboard() -> void:  # C# CallRpcHideScoreboard
	pass

func call_rpc_trigger_retry() -> void:  # C# CallRpcTriggerRetry
	pass

func call_rpc_pass_leaderboard_data(no_coins_list_json: String, all_coins_list_json: String, metadata_json: String) -> void:  # C# CallRpcPassLeaderboardData
	pass

func call_rpc_trigger_start_countdown(countdown_time: int) -> void:  # C# CallRpcTriggerStartCountdown
	pass

func call_rpc_set_slot_status(player_network_number: int, new_state) -> void:  # C# CallRpcSetSlotStatus
	pass

func call_rpc_resync_run_time(host_run_time: float) -> void:  # C# CallRpcResyncRunTime
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
