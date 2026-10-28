# Ported from structur/GameSettings.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GameSettings
extends Resource

class animalColors extends RefCounted:
	var type
	var main_color: Color
	var secondary_color: Color
	var jetpack_hue: float
	var jetpack_sat: float
	var jetpack_val: float

class UserAttributes extends RefCounted:
	var frozen_lobby_code: String
static var music: float
static var sound: float
static var debug: bool
var parsed_matchmaking_number: String
var parsed_version_number_prod: String
var parsed_version_number_to_show: String
var build_stamp: String
var version_number: String
var fake_prod_in_editor: bool
var upload_level_version: int
var use_game_sparks_fqa_server: bool
var radius_modifier: float
var debug_outside_editor: bool
var new_diagonal_mapping: bool
var ignore_save_file_in_editor: bool
var save_debug_xml: bool
var use_secondary_save_file: bool
var online_beta_message_font
var use_debug_unlock: bool
var debug_unlock
var use_debug_unlock_position: bool
var debug_unlock_position: int
var debug_launch_args: String
var use_editor_multiplayer_form_save: bool
var safe_area_scale_ratio: float
var debug_stutter_amount: int
var debug_challenge_ghosts: bool
var smooth_manual_camera_move: Curve
var was_using_custom_rules: bool
var game_mode
var default_game_mode
var mode_locked: bool
var default_ruleset: GameRulePreset
var rule_presets: Array
var rule_preset_list: Array
var ruleset_ind: int
var max_score: int
var max_max_score: int
var min_max_score: int
var max_time: int
var max_max_time: int
var min_max_time: int
var max_rounds: int
var max_max_rounds: int
var min_max_rounds: int
var game_limit_type: int
var u_points: Dictionary
var placement_warn_time: float
var place_time: float
var use_place_timer: bool
var max_place_time: int
var creative_pieces_per_round: int
var max_creative_pieces: int
var party_boxes_per_round: int
var double_party_box: int
var run_timer_limit: int
var min_run_timer: int
var max_run_timer: int
var respawn_mode: int
var num_respawns: int
var min_respawns: int
var max_respawns: int
var party_box_mode: int
var num_last_rounds: int
var max_players: int
var lock_party_button: bool
var player_colors: Array
var system_color: Color
var system_alert_color: Color
var character_colors: Array
var ghost_alpha: float
var highlight_color: Color
var highlight_color_2: Color
var highlight_color_3: Color
var highlight_color_4: Color
var negative_color: Color
var neutral_color: Color
var character_highlight_color: Color
var character_negative_color: Color
var item_pickup_highlight_color: Color
var item_pickup_highlight_color_2: Color
var item_pickup_highlight_time: float
var item_pickup_de_highlight_color: Color
var pickup_speed: float
var putback_speed: float
var inventory_shuffle_timing: float
var inventory_shuffle_extra_delay: float
var respawn_item_shuffle_time: float
var respawn_item_delay: float
var beat_color: Color
var unbeat_color: Color
var blackhole_pull: float
var blackhole_range: Curve
var blackhole_burst_scale: float
var min_point_value: int
var max_point_value: int
var point_value_increment: int
var comeback_streak: int
var rounds_till_sprint_tip: int
var min_sprints: int
var rounds_till_rotate_tip: int
var min_rotates: int
var min_retrys: int
var rounds_till_retry_tip: int
var hint_display_time: float
var hint_min_display_time: float
var rounds_between_hints: int
var animation_delay: float
var hover_scaled_amount: float
var hover_scaled_speed: float
var hover_highlight_speed: float
var cant_change_because_not_host_alpha: float
var disabled_object_alpha: float
var disabled_object_in_game_alpha: float
var diabled_xout_color: Color
var pickable_button_default_hover_color: Color
var party_box_item_scale: float
var two_player_coin_probability: float
var bomb_explode_distance_delay: float
var teleporter_time_curve: Curve
var max_follow_speed_based_on_zoom_modifier: Curve
var boost_effect_curve: Curve
var boost_effect_left_right_curve: Curve
var boost_effect_duration: float
var cannon_rentry_time_out_period: float
var cannon_air_jump_time_out: float
var splash_screen_once: bool
var fav_star_filled: Texture2D
var fav_star_empty: Texture2D
var item_filter: Dictionary
var network_address: String
var network_port: int
var start_as_host: bool
var start_local: bool
var use_unity_relay: bool
var lobby_privacy
var lobby_tag: int
var closest_region
var selected_region
var external_ip: String
var internal_ip: String
var relay_server_connection_data
var region_filter_index: int
var cross_platform_toggle: bool
var enable_twitch_voting: bool
var show_twitch_chat: bool
var twitch_channel_name: String
var twitch_item_animate_speed: float
var steam_name_hide_speed: float
var name_box_time: float
var message_component_fade_speed: float
var online_player_names: int
var quality_score_min: int
var quality_score_max: int
var mid_match_quality: float
var ok_match_score: int
var good_match_score: int
var skill_match_quality_threshold: float
var afk_threshold: float
static var us_relay_uri: String
static var eu_relay_uri: String
static var ap_relay_uri: String
var online_chat_emotes: int
var max_characters_per_message: int
var max_visible_messages: int
var chat_messaging_fade_time: float
var chat_messaging_fade_speed: float
var chat_message_font_size: int
var emote_ui_display_time: float
var emote_ui_fade_speed: float
var max_emotes_per_minute: int
var level_fullness_score_limit: int
var level_thumbnail_width: int
var level_thumbnail_height: int
var level_thumbnail_format: int
var hard_completion_rate: float
var medium_completion_rate: float
var max_local_snapshots: int
var afk_auto_kick_time: int
var current_lobby_afk_auto_kick_time: int
var afk_warning_time: int
var afk_lobby_filter_time: int
var max_failed_heartbeat_checks: int
var bit_summit_build: bool
var forced_controller_visual: bool
var forced_controller_type
var secondary_camera_speed_vs_fov: Curve
var frozen_lobby_code: String
var match_info
static var instance: GameSettings
static var processed_game_settings: bool
static var item_filter_built: bool
var matchmaking_number: String  # C# property
var version_number_prod: String  # C# property
var version_number_dev: String  # C# property
var version_number_to_show: String  # C# property
var full_version_number: String  # C# property
var has_dirty_ruleset: bool  # C# property
var next_preset: GameRulePreset  # C# property
var prev_preset: GameRulePreset  # C# property
var point_types: Array  # C# property
var available_blocks: int  # C# property
static var platform_can_disable_cross_play: bool  # C# property
var current_relay_region_name: String  # C# property
var lobby_privacy_string: String  # C# property
var have_non_default_rules: bool  # C# property

func on_rules_dirty() -> void:  # C# OnRulesDirty
	pass

func get_ruleset_by_index(idx: int) -> GameRulePreset:  # C# GetRulesetByIndex
	return null

func get_current_ruleset() -> GameRulePreset:  # C# GetCurrentRuleset
	return null

func get_ruleset_index(preset: GameRulePreset) -> int:  # C# GetRulesetIndex
	return 0

func partial_load_preset(idx: int, load_rules: bool, load_points: bool, load_blocks: bool, load_modifiers: bool) -> void:  # C# PartialLoadPreset
	pass

func to_preset(idx: int) -> GameRulePreset:  # C# ToPreset
	return null

func to_next_preset() -> GameRulePreset:  # C# ToNextPreset
	return null

func to_prev_preset() -> GameRulePreset:  # C# ToPrevPreset
	return null

func to_default_preset() -> GameRulePreset:  # C# ToDefaultPreset
	return null

func to_last_preset() -> GameRulePreset:  # C# ToLastPreset
	return null

func add_rule_preset(ruleset: GameRulePreset, apply_now: bool) -> void:  # C# AddRulePreset
	pass

func apply_temporary_ruleset(ruleset: GameRulePreset, load_rules: bool, load_points: bool, load_blocks: bool, load_modifiers: bool) -> void:  # C# ApplyTemporaryRuleset
	pass

func remove_rule_preset(ruleset: GameRulePreset) -> void:  # C# RemoveRulePreset
	pass

func reset_to_premade_rulesets() -> void:  # C# ResetToPremadeRulesets
	pass

static func convert_lobby_tag(tag: int) -> String:  # C# ConvertLobbyTag
	return ""

static func load_game_settings_asset(on_success: Callable, on_fail: Callable) -> void:  # C# LoadGameSettingsAsset
	pass

static func get_instance() -> GameSettings:  # C# GetInstance
	return null

static func build_item_filter() -> void:  # C# buildItemFilter
	pass

func point_type_enabled(type) -> bool:  # C# PointTypeEnabled
	return false

func set_point_type_enabled(type, enabled: bool) -> void:  # C# SetPointTypeEnabled
	pass

func always_award_point_type(type) -> bool:  # C# AlwaysAwardPointType
	return false

func set_always_award_point_type(type, always_award: bool) -> void:  # C# SetAlwaysAwardPointType
	pass

func point_type_value(type) -> int:  # C# PointTypeValue
	return 0

func set_point_type_value(type, value: int) -> void:  # C# SetPointTypeValue
	pass

func any_winner_points_enabled() -> bool:  # C# AnyWinnerPointsEnabled
	return false

func point_type_requires_win(type) -> bool:  # C# PointTypeRequiresWin
	return false

func point_type_allowed_for_hotseat(type) -> bool:  # C# PointTypeAllowedForHotseat
	return false

func get_block_frequency(serialize_index: int) -> int:  # C# GetBlockFrequency
	return 0

func set_block_frequency(serialize_index: int, freq: int) -> void:  # C# SetBlockFrequency
	pass

func available_blocks_2() -> int:  # C# availableBlocks
	return 0

func read_game_rules(other_preset: GameRulePreset) -> void:  # C# ReadGameRules
	pass

func read_modifiers(other_preset: GameRulePreset) -> void:  # C# ReadModifiers
	pass

func read_point_settings(other_preset: GameRulePreset) -> void:  # C# ReadPointSettings
	pass

static func ensure_item_filter_built() -> void:  # C# EnsureItemFilterBuilt
	pass

func read_block_settings(other_preset: GameRulePreset) -> void:  # C# ReadBlockSettings
	pass

func set_all_defaults() -> void:  # C# SetAllDefaults
	pass

func read_all_settings(other_preset: GameRulePreset) -> void:  # C# ReadAllSettings
	pass

func apply_save_file_overrides() -> void:  # C# ApplySaveFileOverrides
	pass

func on_game_start() -> void:  # C# OnGameStart
	pass

func on_treehouse_start() -> void:  # C# OnTreehouseStart
	pass

func reset_mods_to_defaults() -> void:  # C# ResetModsToDefaults
	pass

static func get_point_limit_value_string(max_score: int) -> String:  # C# GetPointLimitValueString
	return ""

static func get_length_limit_value_string(game_limit_type: int, max_rounds: int, max_time: int) -> String:  # C# GetLengthLimitValueString
	return ""

static func get_placement_timer_value_string(use_place_timer: bool, place_time: float) -> String:  # C# GetPlacementTimerValueString
	return ""

static func get_run_timer_value_string(run_timer_limit: int) -> String:  # C# GetRunTimerValueString
	return ""

static func get_double_party_box_value_string(double_party_box: int) -> String:  # C# GetDoublePartyBoxValueString
	return ""

static func get_respawn_mode_value_string(respawn_mode: int, num_respawns: int) -> String:  # C# GetRespawnModeValueString
	return ""

static func get_party_box_mode_value_string(party_box_mode: int) -> String:  # C# GetPartyBoxModeValueString
	return ""

func get_rules_list_string(in_lobby: bool) -> String:  # C# GetRulesListString
	return ""
