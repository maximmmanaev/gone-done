# Каркас из structur/Ice.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Ice
extends MultipiecePart

@export var slickness: float = 0.9



func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return [{"ground_friction": 1.0 - slickness}]

func _ready() -> void:
	setup_zone(Vector2(16, 6), Vector2(0, -6))
