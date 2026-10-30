# Каркас из AnimalCannon.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Пушка: втягивает персонажа, держит time_to_launch, затем выстреливает им по направлению dir.
class_name AnimalCannon
extends ActiveBlock

@export var time_to_launch: float = 1.0        # C# TimeToLaunch (значение GUESS)
@export var launch_anticipation: float = 0.3   # C# LaunchAnticipation (GUESS)
@export var launch_speed: float = 420.0        # GUESS
@export var input_lock_after_launch: float = 0.3   # GUESS
@export var recapture_cooldown: float = 0.8    # GUESS
var dir := Vector2.UP
var muzzle_offset := 20.0
var chrs_in_cannon: Dictionary = {}   # Character -> время в пушке (C# chrsInCannonData)
var _cooldowns: Dictionary = {}
var _flying: Dictionary = {}   # Character -> сколько ещё держим скорость выстрела (иначе трение гасит её сразу)
@export var flight_time: float = 0.35   # GUESS
var barrel: Node2D


func act(delta: float) -> void:
	for c in _flying.keys():
		_flying[c] -= delta
		if not is_instance_valid(c) or _flying[c] <= 0.0 or c.dead or c.dying:
			_flying.erase(c)
		elif dir.x != 0.0:
			c.velocity.x = dir.x * launch_speed
	for c in _cooldowns.keys():
		_cooldowns[c] -= delta
		if not is_instance_valid(c) or _cooldowns[c] <= 0.0:
			_cooldowns.erase(c)
	for c: Character in zone_characters:
		if is_instance_valid(c) and not chrs_in_cannon.has(c) and not _cooldowns.has(c) \
				and not c.dead and not c.dying and not c.is_ghost and not c.success:
			chrs_in_cannon[c] = 0.0
			c.freeze(true)
			c.velocity = Vector2.ZERO
	for c in chrs_in_cannon.keys():
		if not is_instance_valid(c) or c.dead or c.dying:
			if is_instance_valid(c):
				c.unfreeze()
			chrs_in_cannon.erase(c)
			continue
		chrs_in_cannon[c] += delta
		c.global_position = global_position
		if chrs_in_cannon[c] >= time_to_launch:
			_launch(c)


func _launch(c: Character) -> void:
	chrs_in_cannon.erase(c)
	c.unfreeze()
	c.global_position = global_position + dir * muzzle_offset
	c.velocity = dir * launch_speed
	c.lock_input_temporarily(input_lock_after_launch)
	_cooldowns[c] = recapture_cooldown
	_flying[c] = flight_time


func reset_play_state() -> void:
	for c in chrs_in_cannon.keys():
		if is_instance_valid(c):
			c.unfreeze()
	chrs_in_cannon.clear()
	_cooldowns.clear()
	_flying.clear()
	super()
