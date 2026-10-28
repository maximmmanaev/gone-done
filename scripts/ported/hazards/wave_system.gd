# Ported from structur/WaveSystem.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WaveSystem
extends Node2D

@export var frontwaves: Node2D
@export var backwaves: Node2D
@export var very_front_waves: Node2D
var front_waves_sr: Array
var backwaves_sr: Array
var very_front_sr: Array
@export var front_wave_color: Color
@export var back_wave_color: Color
@export var very_front_wave_color: Color
var frontwave_animators: Array
var back_wave_animators: Array
var very_front_waves_animator: Array
@export var front_animator_speed: float
@export var back_animator_speed: float
@export var very_front_animator_speed: float
@export var update_always: bool
@export var dont_update_layer_order: bool

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func update_everything() -> void:  # C# updateEverything
	pass
