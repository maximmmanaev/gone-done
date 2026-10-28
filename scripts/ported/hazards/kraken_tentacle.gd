# Ported from structur/KrakenTentacle.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name KrakenTentacle
extends Node2D

static var attack_type: int
var visual_animator: AnimationPlayer
var maximum_position_y: float
var minimum_position_y: float
var kraken_splash_animator: AnimationPlayer
var possible_attack_indexes: Array
var pivot: Node2D
var random: SyncedRandom
var all_animators: Array
var current_anim_index: int
var side: int

func _enter_tree() -> void:  # C# Awake
	pass

func start_tentacle() -> void:  # C# StartTentacle
	pass

func pre_select_attack(attack_index: int) -> void:  # C# PreSelectAttack
	pass

func play_feedback() -> void:  # C# PlayFeedback
	pass

func do_pause() -> void:  # C# DoPause
	pass

func do_unpause() -> void:  # C# DoUnpause
	pass

func do_reset():  # C# DoReset
	pass

func debug_set_random() -> void:  # C# DebugSetRandom
	pass

func set_random(random: SyncedRandom) -> void:  # C# SetRandom
	pass
