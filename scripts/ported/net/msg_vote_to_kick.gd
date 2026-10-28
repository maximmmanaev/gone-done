# Ported from structur/MsgVoteToKick.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgVoteToKick
extends RefCounted

var network_player_to_kick: int
var network_player_voting: int
var vote_to_kick: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
