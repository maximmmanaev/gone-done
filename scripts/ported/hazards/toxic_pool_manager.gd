# Ported from structur/ToxicPoolManager.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ToxicPoolManager
extends Node2D

static var opened: int
static var leaking: int
var pool_bubbles: Array
@export var pool_gate_animator: AnimationPlayer
@export var toxic_waste_base_animator: AnimationPlayer
@export var toxic_waste_waterfall_animator: AnimationPlayer
@export var valve_animator: AnimationPlayer
@export var bubbles_leaking_animator: AnimationPlayer

func _enter_tree() -> void:  # C# Awake
	pass

func do_reset() -> void:  # C# DoReset
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func start_pool_fill_sound() -> void:  # C# StartPoolFillSound
	pass

func start_open_gate() -> void:  # C# StartOpenGate
	pass

func start_waterfall_base() -> void:  # C# StartWaterfallBase
	pass

func start_waterfall() -> void:  # C# StartWaterfall
	pass

func start_close_gate() -> void:  # C# StartCloseGate
	pass

func stop_bubbles_leaking() -> void:  # C# StopBubblesLeaking
	pass

func stop_waterfall() -> void:  # C# StopWaterfall
	pass
