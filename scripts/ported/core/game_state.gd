# Ported from structur/GameState.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GameState
extends Node2D

enum GameMode {
	FREEPLAY,
	CREATIVE,
	PARTY,
	CHALLENGE,
}

enum LevelName {
	FARM = 0,
	ROOFTOPS = 1,
	OLDMANSION = 2,
	WATERFALL = 3,
	PYRAMID = 4,
	WINDMILL = 5,
	METALPLANT = 6,
	ICEBERG = 7,
	DANCEPARTY = 8,
	PIER = 9,
	BLANKLEVEL = 10,
	JUNGLETEMPLE = 11,
	VOLCANO = 12,
	CRUMBLINGBRIDGE = 13,
	NUCLEARPLANT = 14,
	TRONLEVEL = 15,
	SPACELEVEL = 16,
	BALLROOM = 17,
	ROLLERCOASTER = 18,
	METRO = 19,
	WATERTOWER = 20,
	RAFT = 21,
	RANDOM = 100,
	PROTOTYPE1 = 101,
	PROTOTYPE2 = 102,
	PROTOTYPE3 = 103,
	PROTOTYPE4 = 104,
	PROTOTYPE5 = 105,
	PROTOTYPE6 = 106,
}

enum PortalID {
	FARM = 0,
	ROOFTOPS = 1,
	OLDMANSION = 2,
	WATERFALL = 3,
	PYRAMID = 4,
	WINDMILL = 5,
	METALPLANT = 6,
	ICEBERG = 7,
	DANCEPARTY = 8,
	PIER = 9,
	BLANKLEVEL = 10,
	JUNGLETEMPLE = 11,
	VOLCANO = 12,
	CRUMBLINGBRIDGE = 13,
	NUCLEARPLANT = 14,
	TRONLEVEL = 15,
	CUSTOMA = 16,
	CUSTOMB = 17,
	CUSTOMC = 18,
	CUSTOMD = 19,
	SPACELEVEL = 20,
	BALLROOM = 21,
	ROLLERCOASTER = 22,
	METRO = 23,
	WATERTOWER = 24,
	RAFT = 25,
	RANDOM = 100,
	PROTOTYPE1 = 101,
	PROTOTYPE2 = 102,
	PROTOTYPE3 = 103,
	PROTOTYPE4 = 104,
	PROTOTYPE5 = 105,
	PROTOTYPE6 = 106,
}
static var mode_list: Array
static var instance: GameState
static var was_destroyed: bool
var onscreen_prefixes: Array
var keyboard
var controllers: Array
var player_scores: Array
var selected_level
var next_unlocks: Dictionary
var guaranteed_unlocks: Dictionary
@export var using_hot_seat: bool
var started: bool
static var debug_mode: bool
static var debug_mode_ui: bool
static var online_debug_mode: bool
static var extra_data_debug_mode: bool
static var flags_dont_win: bool
@export var paused: bool
@export var time_started: float
@export var time_elapsed: float
var piece_count: Dictionary
var control_tips
var current_sort_order_number: int
static var chat_system
@export var preserve_players: bool
@export var last_lobby_score: int
var current_snapshot_info
@export var last_level_played: String
@export var auto_start_hosting: bool
@export var auto_join_invited_game: bool
var debug_text_row: int
static var number_of_text_rows: int
var textheight: int
static var debug_string_list: Array
var opacity_cutoff_height: int
var distance_from_present: int
var debug_style
var debug_style_bg
var beta_message
var debug_extra_data_style
var version_rect: Rect2

static func next_mode(current):  # C# NextMode
	pass

static func previous_mode(current):  # C# PreviousMode
	pass

static func mode_is_allowed(mode) -> bool:  # C# ModeIsAllowed
	return false

static func get_level_scene_name(level) -> String:  # C# GetLevelSceneName
	return ""

static func get_level_localized_name(level) -> String:  # C# GetLevelLocalizedName
	return ""

static func get_level_localization_term(level) -> String:  # C# GetLevelLocalizationTerm
	return ""

static func get_localization_version_number() -> String:  # C# GetLocalizationVersionNumber
	return ""

static func get_level_mus_string(level) -> String:  # C# GetLevelMusString
	return ""

static func get_level_ambience_string(level) -> String:  # C# GetLevelAmbienceString
	return ""

static func get_instance() -> GameState:  # C# GetInstance
	return null

func _ready() -> void:  # C# Start
	pass

static func toggle_debug_mode() -> void:  # C# ToggleDebugMode
	pass

static func toggle_debug_mode_no_special_ui() -> void:  # C# ToggleDebugModeNoSpecialUI
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func on_enable() -> void:  # C# OnEnable
	pass

func on_disable() -> void:  # C# OnDisable
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func cleanup_before_quit() -> void:  # C# CleanupBeforeQuit
	pass

func attach_device_to_controller(d) -> void:  # C# AttachDeviceToController
	pass

func remove_device_from_controller(d) -> void:  # C# RemoveDeviceFromController
	pass

func reset_piece_count() -> void:  # C# ResetPieceCount
	pass

func decrement_piece_count(name: String) -> void:  # C# DecrementPieceCount
	pass

func increment_piece_count(name: String) -> void:  # C# IncrementPieceCount
	pass

func set_piece_count(name: String, value: int) -> void:  # C# SetPieceCount
	pass

func get_piece_count(name: String) -> int:  # C# GetPieceCount
	return 0

func send_start_analytics() -> void:  # C# SendStartAnalytics
	pass

func send_end_analytics() -> void:  # C# SendEndAnalytics
	pass

func set_gui_style() -> void:  # C# SetGuiStyle
	pass

func set_gui_style_opacity(opacity: float) -> void:  # C# SetGuiStyleOpacity
	pass

func draw_debug_text_1(text: String) -> void:  # C# DrawDebugText
	pass

func draw_debug_text_3(text: String, color: Color, bg: Color) -> void:  # C# DrawDebugText
	pass

func draw_debug() -> void:  # C# DrawDebug
	pass

static func write_online(newline: String) -> void:  # C# writeOnline
	pass

func draw_extra_data_debug(text: String, screen_position: Vector2, color: Color) -> void:  # C# DrawExtraDataDebug
	pass

func handle_onscreen_log(log_string: String, stack_trace: String, type) -> void:  # C# HandleOnscreenLog
	pass

func on_application_focus(focus: bool) -> void:  # C# OnApplicationFocus
	pass

func open_reddit_url_in_a_second():  # C# OpenRedditUrlInASecond (coroutine)
	pass

static func on_scene_change() -> void:  # C# OnSceneChange
	pass

static func get_localized_game_mode_name(game_mode) -> String:  # C# GetLocalizedGameModeName
	return ""
