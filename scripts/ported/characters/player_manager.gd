# Ported from structur/PlayerManager.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PlayerManager
extends RefCounted

var player_count: int
static var max_players: int
var player_list: Array
var first_user_logged_in: bool
static var instance: PlayerManager
var num_players: int  # C# property

static func get_instance() -> PlayerManager:  # C# GetInstance
	return null

func add_player_1(control: Controller) -> PlayerUnity:  # C# AddPlayer
	return null

func get_player(number: int) -> PlayerUnity:  # C# GetPlayer
	return null

func remove_player_1(number: int) -> PlayerUnity:  # C# RemovePlayer
	return null

func clear_all_players() -> void:  # C# ClearAllPlayers
	pass

func clear_first_login(send_driving_player_removed_event: bool) -> void:  # C# ClearFirstLogin
	pass

func set_first_login() -> void:  # C# SetFirstLogin
	pass

func get_player_local_number_for_animal(animal) -> int:  # C# GetPlayerLocalNumberForAnimal
	return 0
