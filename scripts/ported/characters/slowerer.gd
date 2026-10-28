# Ported from structur/Slowerer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Slowerer
extends Node2D

static var instance: Slowerer
@export var delay_update: bool
@export var delay_fixed_update: bool
@export var minimum_delay_milliseconds: int

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass
