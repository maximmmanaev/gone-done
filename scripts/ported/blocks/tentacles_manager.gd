# Ported from structur/TentaclesManager.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name TentaclesManager
extends ActiveBlock

var start_x_spawn_range: Node2D
var end_x_spawn_range: Node2D
var spawn_zone_percentage: float
var random: SyncedRandom
var tentacles: Array
var camera_shaker: CameraShaker
var used_attacks_count: Dictionary
var shuffled_tentacles: Array

func _enter_tree() -> void:  # C# Awake
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func trigger_tentacles(random_seed: int):  # C# TriggerTentacles
	pass

func pre_select_attack(tentacle: KrakenTentacle) -> void:  # C# PreSelectAttack
	pass
