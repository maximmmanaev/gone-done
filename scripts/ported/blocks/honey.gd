# Каркас из structur/Honey.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Honey
extends Placeable

@export var stickiness: float = 0.5
@export var jump_stickiness: float = 0.3



func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return [{"ground_friction": 1.0 + stickiness * 2.0, "run_speed": 1.0 - stickiness * 0.5, "jump_force": 1.0 - jump_stickiness * 0.5}]

func _ready() -> void:
	setup_zone(Vector2(16, 6), Vector2(0, -6))
