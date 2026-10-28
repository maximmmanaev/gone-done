# Ported from structur/ScoreLine.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ScoreLine
extends Node2D

@export var next_attach_position: Vector3
var score_board_parent
var drawing: bool
var last_new_scorepiece
@export var locked_after_scoring: bool
@export var disconnected: bool
var animal
@export var animal_image: TextureRect
@export var animal_name: Label
var name_tag
@export var come_back: Label
@export var handicap_text: Label
@export var handicap: int
@export var textbacking: TextureRect
var score_pieces: Array
@export var image_connected_color: Color
@export var long_name_image_connected_color: Color
@export var image_disconnected_color: Color
@export var long_name_threshold: int

func _ready() -> void:  # C# Start
	pass

func add_score_point_block(pb: PointBlock) -> void:  # C# AddScorePointBlock
	pass

func draw_score_piece():  # C# DrawScorePiece (coroutine)
	pass

func activate_comeback() -> void:  # C# ActivateComeback
	pass

func de_activate_comeback() -> void:  # C# DeActivateComeback
	pass

func set_handicap(new_handicap: int) -> void:  # C# SetHandicap
	pass

func set_disconnected(disconnect: bool) -> void:  # C# SetDisconnected
	pass

func clear_last_new_score_piece() -> void:  # C# clearLastNewScorePiece
	pass

func use_animal_name(name: String) -> void:  # C# UseAnimalName
	pass

func use_player_name(lobby_pl) -> void:  # C# UsePlayerName
	pass

func showtext_backing(show: bool) -> void:  # C# ShowtextBacking
	pass
