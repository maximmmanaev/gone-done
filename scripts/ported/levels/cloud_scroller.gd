# Ported from structur/CloudScroller.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CloudScroller
extends Node2D

@export var cloud_scroll_speed: float
@export var random_speed_range: float
@export var cloud_start: Node2D
@export var cloud_end: Node2D
@export var cloud_holder: Node2D
var clouds: Array
var clouds_enabled: bool

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass
