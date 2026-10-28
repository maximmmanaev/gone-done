# Ported from structur/CoinStatusDisplay.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CoinStatusDisplay
extends Node2D

@export var coin: TextureRect
@export var checkmark: TextureRect
var icon_canvas: CanvasLayer
var canvas_group
@export var fade_time: float
var total_coins: int
var collected_coins: int
var showing: bool

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func show_0() -> void:  # C# Show
	pass

func set_alpha_1(alpha: float) -> void:  # C# SetAlpha
	pass

func fade_to_alpha_1(target_alpha: float) -> void:  # C# FadeToAlpha
	pass

func fade_to_alpha_2(target_alpha: float, fade_time: float) -> void:  # C# FadeToAlpha
	pass

func fade_alpha_to_courotine(target_alpha: float, fade_time: float):  # C# FadeAlphaToCourotine (coroutine)
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
