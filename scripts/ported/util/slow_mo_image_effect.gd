# Ported from structur/SlowMoImageEffect.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SlowMoImageEffect
extends Node2D

@export var fisheye_strength: float
@export var saturation: float
var fisheye_mat: Material
var curr_fisheye: float
var curr_sat: float

func on_render_image(source, destination) -> void:  # C# OnRenderImage
	pass

func _process(delta: float) -> void:  # C# Update
	pass
