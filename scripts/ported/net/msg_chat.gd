# Ported from structur/MsgChat.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgChat
extends RefCounted

var network_player_number: int
var emote_type: int
var message_text: String
var is_chat_message: bool

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
