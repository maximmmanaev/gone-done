# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Вращающийся блок: каждые interval поворачивается на degrees со скоростью rotate_speed (по часовой, если clockwise).
class_name RotateBlock
extends ActiveBlock

@export var degrees: float = 90.0         # C# Degrees (значение GUESS)
@export var rotate_speed: float = 120.0   # C# RotateSpeed (GUESS), градусов в секунду
@export var interval: float = 2.0         # C# Interval (GUESS)
@export var clockwise := true             # C# Clockwise = true
var rotate_amt := 0.0
var rotate_time := 0.0
var _turning := false
var _wait := 0.0
var body: AnimatableBody2D


func setup_body(b: AnimatableBody2D) -> void:
	body = b
	body.sync_to_physics = true


func act(delta: float) -> void:
	if body == null:
		return
	if not _turning:
		_wait += delta
		if _wait >= interval:
			_wait = 0.0
			_turning = true
			rotate_amt = 0.0
		return
	var step := minf(rotate_speed * delta, degrees - rotate_amt)
	rotate_amt += step
	body.rotation_degrees += step if clockwise else -step
	if rotate_amt >= degrees - 0.001:
		_turning = false


func reset_play_state() -> void:
	_turning = false
	_wait = 0.0
	rotate_amt = 0.0
	if body != null:
		body.rotation = 0.0
	super()
