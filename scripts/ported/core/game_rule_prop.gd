# Ported from structur/GameRuleProp.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name GameRuleProp
extends UsableProp

static var game_rule_book
var target_page
@export var audio_string: String

func _ready() -> void:  # C# Start
	pass

func use(lobby_player, used_input_key) -> bool:  # C# Use
	return false
