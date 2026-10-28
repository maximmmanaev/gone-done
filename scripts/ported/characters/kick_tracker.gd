# Ported from structur/KickTracker.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name KickTracker
extends RefCounted

var votes: Array

func set_vote(voting_player: int, target_player: int, vote_to_kick: bool) -> void:  # C# SetVote
	pass

func get_vote(voting_player: int, target_player: int) -> bool:  # C# GetVote
	return false

func clear_player(player: int) -> void:  # C# ClearPlayer
	pass

func count_votes(target_player: int) -> int:  # C# CountVotes
	return 0

func votes_from_network_number(network_number: int) -> Array:  # C# VotesFromNetworkNumber
	return []
