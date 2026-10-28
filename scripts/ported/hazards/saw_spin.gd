# Каркас из structur/SawSpin.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name SawSpin
extends Node2D

@export var spin_speed: float = 8.0

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	rotation += spin_speed * delta
