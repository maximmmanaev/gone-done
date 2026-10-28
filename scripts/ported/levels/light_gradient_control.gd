# Ported from structur/LightGradientControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name LightGradientControl
extends Node2D

@export var light_gradient_tint: Color
@export var gradient_top: Node2D
@export var gradient_bottom: Node2D
var last_top_position: Vector2
var last_bottom_position: Vector2
var sprite_litmaterial: Material
var sprite_litmaterial_hsv: Material

func _ready() -> void:  # C# Start
	pass

func wait_for_material():  # C# waitForMaterial (coroutine)
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func set_allmaterials() -> void:  # C# SetAllmaterials
	pass

func set_sprite_gradient(mat: Material) -> void:  # C# SetSpriteGradient
	pass
