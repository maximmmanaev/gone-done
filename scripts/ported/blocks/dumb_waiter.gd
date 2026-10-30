# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Подъёмник: когда на него встали, через net_movement_delay едет вверх на move_distance и остаётся наверху.
class_name DumbWaiter
extends ActiveBlock

@export var net_movement_delay: float = 0.5   # C# netMovementDelay = 0.5f
@export var move_distance: float = 96.0       # GUESS
@export var move_speed: float = 55.0          # GUESS
var movement_activated := false
var _delay := 0.0
var _moved := 0.0
var body: AnimatableBody2D
var _start := Vector2.ZERO


func setup_body(b: AnimatableBody2D, size: Vector2) -> void:
	body = b
	body.sync_to_physics = true
	_start = b.position
	setup_zone(Vector2(size.x - 2.0, 6.0), Vector2(0, -size.y / 2.0 - 3.0))


func act(delta: float) -> void:
	if body == null:
		return
	if not movement_activated:
		for c: Character in zone_characters:
			if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
				movement_activated = true
				_delay = 0.0
		return
	_delay += delta
	if _delay < net_movement_delay or _moved >= move_distance:
		return
	var step := minf(move_speed * delta, move_distance - _moved)
	_moved += step
	body.position.y -= step


func reset_play_state() -> void:
	movement_activated = false
	_delay = 0.0
	_moved = 0.0
	if body != null:
		body.position = _start
	super()
