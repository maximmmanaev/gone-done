# Ported from structur/Lighter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Lighter
extends ActiveBlock

@export var animator: AnimationPlayer
@export var fire_hazard: CollisionShape2D
@export var interval: float
var timer: float
var lighter_on: bool
@export var dial_holder: Node2D

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func set_lighter_hazard_state(on_off: bool) -> void:  # C# SetLighterHazardState
	pass
