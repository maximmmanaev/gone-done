# Ported from structur/ScoreKeeper.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ScoreKeeper
extends RefCounted

class scoreInfo extends RefCounted:
	var total_score: int
	var lose_streak: int
	var win_streak: int
	var disconnected: bool
static var instance: ScoreKeeper
var new_point_blocks: Array
var history_point_blocks: Array
var player_total: Dictionary
var is_on_server: bool

func setup() -> void:  # C# Setup
	pass

func change_listeners(adding: bool) -> void:  # C# ChangeListeners
	pass

func award_point(point_block: PointBlock, add_immediate: bool) -> bool:  # C# AwardPoint
	return false

func tally_point_block_all_players(check_streaks: bool) -> void:  # C# TallyPointBlockAllPlayers
	pass

func clear_new_point_blocks(clear_all: bool) -> void:  # C# ClearNewPointBlocks
	pass

func remove_special_points() -> void:  # C# RemoveSpecialPoints
	pass

func are_there_coin_points() -> bool:  # C# AreThereCoinPoints
	return false

func are_there_non_coin_points() -> bool:  # C# AreThereNonCoinPoints
	return false

func mark_player_disconnected(player: GamePlayer) -> void:  # C# MarkPlayerDisconnected
	pass

func get_player_total(player: GamePlayer) -> int:  # C# GetPlayerTotal
	return 0

func add_points_directly(player: GamePlayer, points: int) -> void:  # C# AddPointsDirectly
	pass

func get_player_lose_streak(player: GamePlayer) -> int:  # C# GetPlayerLoseStreak
	return 0

func get_player_win_streak(player: GamePlayer) -> int:  # C# GetPlayerWinStreak
	return 0

func is_player_in_lose_streak(player_number: int) -> bool:  # C# IsPlayerInLoseStreak
	return false

func get_player_lose_streak_2(player_number: int) -> int:  # C# GetPlayerLoseStreak
	return 0

func get_player_win_streak_2(player_number: int) -> int:  # C# GetPlayerWinStreak
	return 0

func clear_score() -> void:  # C# ClearScore
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func on_point_earned_for_player(p: PlayerUnity, save_file_data, stat_name: String, point_type) -> void:  # C# OnPointEarnedForPlayer
	pass

func add_point_block(point_block: PointBlock) -> void:  # C# addPointBlock
	pass

func special_point_check(player: GamePlayer) -> bool:  # C# SpecialPointCheck
	return false
