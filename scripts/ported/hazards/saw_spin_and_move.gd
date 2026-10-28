# Каркас из structur/SawSpinAndMove.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name SawSpinAndMove
extends Node2D

@export var spin_speed: float = 8.0
@export var move_speed: float = 40.0
@export var going_left: bool
@export var going_right: bool
@export var max_left: float = 48.0
@export var max_right: float = 48.0

func _ready() -> void:  # C# Start
	_origin_x = position.x
	if not going_left and not going_right:
		going_right = true

func _process(delta: float) -> void:  # C# Update
	rotation += spin_speed * delta
	var dx := move_speed * delta
	if going_right:
		position.x += dx
		if position.x >= _origin_x + max_right:
			position.x = _origin_x + max_right
			going_right = false
			going_left = true
	elif going_left:
		position.x -= dx
		if position.x <= _origin_x - max_left:
			position.x = _origin_x - max_left
			going_left = false
			going_right = true

var _origin_x := 0.0
