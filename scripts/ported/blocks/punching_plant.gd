# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Растение-боксёр: заметило персонажа перед собой — через fear_time бьёт и отбрасывает всех в зоне; не убивает.
class_name PunchingPlant
extends ActiveBlock

@export var punch_strength: float = 380.0   # C# PunchStrength (значение GUESS)
@export var fear_time: float = 0.3          # C# FearTime (GUESS): время замаха
@export var cooldown: float = 1.0           # GUESS
@export var punch_lift: float = 80.0        # GUESS
var dir := Vector2.RIGHT
var afraid := false
var punching := false
var _t := 0.0
var _cool := 0.0
var visual: Node2D
var _base_scale := Vector2.ONE


## Картинка растения; её масштаб под размер клетки запоминаем, чтобы анимация удара его не сбрасывала.
func set_visual(v: Node2D) -> void:
	visual = v
	_base_scale = v.scale


func act(delta: float) -> void:
	_cool = maxf(_cool - delta, 0.0)
	if punching:
		_t += delta
		if visual != null:
			visual.scale = _base_scale * (1.0 + 0.25 * sin(clampf(_t / 0.25, 0.0, 1.0) * PI))
		if _t >= 0.25:
			punching = false
			if visual != null:
				visual.scale = _base_scale
		return
	if afraid:
		_t += delta
		if _t >= fear_time:
			afraid = false
			_punch()
		return
	if _cool > 0.0:
		return
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
			afraid = true
			_t = 0.0
			return


func _punch() -> void:
	punching = true
	_t = 0.0
	_cool = cooldown
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying:
			c.add_impulse(dir * punch_strength + Vector2(0, -punch_lift))


func reset_play_state() -> void:
	afraid = false
	punching = false
	_t = 0.0
	_cool = 0.0
	if visual != null:
		visual.scale = _base_scale
	super()
