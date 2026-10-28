# Ported from structur/GameRulePreset.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GameRulePreset
extends Resource

class PointData extends RefCounted:
	var type
	var u_enabled: bool
	var value: int
	var always_award: bool
	var requires_win: bool
	var hotseat_allowed: bool

class BlockData extends RefCounted:
	var block_placeable: Placeable
	var frequency: int
	const DEFAULT_FREQUENCY: int = 5
	const MAX_FREQUENCY: int = 9
	var u_enabled: bool  # C# property
var u_name: String
var description: String
var is_premade: bool
var name_has_localization: bool
var path_to_file: String
var max_score: int
var max_rounds: int
var max_time: int
var place_time: float
var use_place_timer: bool
var game_limit_type: int
var double_party_box: int
var run_timer_limit: int
var creative_pieces_per_round: int
var respawn_mode: int
var num_respawns: int
var party_box_mode: int
var u_points: Dictionary
var win_default
var win_solo_default
var trap_default
var comeback_default
var coin_default
var postmortem_default
var first_default
var second_default
var third_default
var fourth_default
var blocks: Array
var mods: ModSource
var localized_name: String  # C# property
var localized_description: String  # C# property
var point_types: Array  # C# property

func block_frequency(block: Placeable) -> int:  # C# BlockFrequency
	return 0

func setup_points() -> void:  # C# setupPoints
	pass

func point_type_enabled(type) -> bool:  # C# PointTypeEnabled
	return false

func always_award_point_type(type) -> bool:  # C# AlwaysAwardPointType
	return false

func point_type_value(type) -> int:  # C# PointTypeValue
	return 0

func any_winner_points_enabled() -> bool:  # C# AnyWinnerPointsEnabled
	return false

func point_type_requires_win(type) -> bool:  # C# PointTypeRequiresWin
	return false

func point_type_allowed_for_hotseat(type) -> bool:  # C# PointTypeAllowedForHotseat
	return false

func load_rules_from_settings() -> void:  # C# LoadRulesFromSettings
	pass

func is_currently_applied_4(check_rules: bool, check_points: bool, check_blocks: bool, check_mods: bool) -> bool:  # C# IsCurrentlyApplied
	return false

func load_ruleset_from_xml(xml) -> void:  # C# LoadRulesetFromXML
	pass

func get_ruleset_xml_string() -> String:  # C# GetRulesetXmlString
	return ""

func get_ruleset_xml():  # C# GetRulesetXml
	pass

static func load_all_saved_rulesets(clear_existing: bool) -> void:  # C# LoadAllSavedRulesets
	pass

static func load_rules(filename: String, apply_on_load: bool) -> void:  # C# LoadRules
	pass

static func get_rules_filenames(extension_filter: String, on_finish: Callable) -> void:  # C# getRulesFilenames
	pass

static func delete_ruleset(ruleset: GameRulePreset, on_finish: Callable) -> void:  # C# DeleteRuleset
	pass

static func get_ruleset_from_current_rules() -> GameRulePreset:  # C# GetRulesetFromCurrentRules
	return null

static func save_rules(name_input: String, description_input: String, on_name_sanitized: Callable, on_ruleset_created: Callable) -> void:  # C# SaveRules
	pass

static func get_valid_filename(suggested_filename: String, existing_files: Array) -> String:  # C# getValidFilename
	return ""

func get_name_string() -> String:  # C# GetNameString
	return ""

func get_description_string() -> String:  # C# GetDescriptionString
	return ""

func generate_apply_ruleset_message(load_rules: bool, load_points: bool, load_blocks: bool, load_mods: bool) -> MsgApplyRuleset:  # C# GenerateApplyRulesetMessage
	return null
