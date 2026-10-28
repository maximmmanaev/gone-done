# Ported from structur/Player.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PlayerUnity
extends RefCounted

var turn_order: int
var freeplay_phase
var hotseat_player: bool
var removed: bool
var logged_out: bool
var character: Character
var cursor: CursorUnity
var controller: Controller
var assoc_lobby_player
var assoc_game_player: GamePlayer
var connected: bool
var number: int  # C# property
var player_character: Character  # C# property
var player_cursor: CursorUnity  # C# property
var use_controller: Controller  # C# property
var associated_lobby_player  # C# property
var associated_game_player: GamePlayer  # C# property
