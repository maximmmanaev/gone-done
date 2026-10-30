# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Нажимная плита: наступил — через trigger_delay из неё выскакивают шипы и убивают тех, кто остался на плите.
class_name PressureTriggerSpikes
extends ActiveBlock

@export var lock_out_time: float = 1.0       # C# lockOutTime = 1f
@export var trigger_delay: float = 0.15      # GUESS
@export var spike_time: float = 0.5          # GUESS
var triggered := false
var lock_out_timer := 0.0
var _t := 0.0
var _spikes_up := false
var death_trigger_once := false


func act(delta: float) -> void:
	lock_out_timer = maxf(lock_out_timer - delta, 0.0)
	if not triggered:
		if lock_out_timer <= 0.0 and _someone_on_plate():
			triggered = true
			_t = 0.0
		return
	_t += delta
	if not _spikes_up and _t >= trigger_delay:
		_spikes_up = true
		death_trigger_once = false
	if _spikes_up:
		if not death_trigger_once:
			death_trigger_once = true
			for c: Character in zone_characters:
				if is_instance_valid(c):
					c.kill_character("spikes", self)
		if _t >= trigger_delay + spike_time:
			triggered = false
			_spikes_up = false
			lock_out_timer = lock_out_time


func _someone_on_plate() -> bool:
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
			return true
	return false


func reset_play_state() -> void:
	triggered = false
	_spikes_up = false
	lock_out_timer = 0.0
	_t = 0.0
	death_trigger_once = false
	super()
