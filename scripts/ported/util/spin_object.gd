# Ported from structur/SpinObject.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SpinObject
extends Node2D

@export var speed: float
@export var clockwise: bool
@export var random_speed: bool
@export var random_min: float
@export var random_max: float
var paused: bool
var scoreboard: bool

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
