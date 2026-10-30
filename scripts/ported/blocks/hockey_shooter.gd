# Каркас из HockeyShooter.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Хоккейный стрелок: через initial_delay, потом каждые interval, выпускает шайбу по направлению dir.
class_name HockeyShooter
extends ActiveBlock

@export var initial_delay: float = 1.0    # C# initialDelay (значение GUESS)
@export var interval: float = 2.5         # C# interval (значение GUESS)
@export var push_character_strength: float = 300.0   # C# pushCharacterStrength (GUESS)
@export var vertical_push_extra: float = 90.0        # C# VerticalPushExtra (GUESS)
@export var puck_speed: float = 220.0     # GUESS
var dir := Vector2.RIGHT
var muzzle_offset := 12.0
var shooting: bool
var pucks_fired := 0
var pucks: Array = []
var _last_index := -1


func act(_delta: float) -> void:
	var t := play_clock() - initial_delay
	if t < 0.0:
		return
	var index := floori(t / interval)
	if index != _last_index:
		_last_index = index
		shoot()


func shoot() -> void:
	var puck := HockeyPuck.new()
	puck.direction = dir
	puck.speed = puck_speed
	puck.push_character_strength = push_character_strength
	puck.vertical_push_extra = vertical_push_extra
	puck.position = position + dir * muzzle_offset
	var art: Node2D = BlockArt.make("hockeypuck", Vector2(10, 10))
	if art != null:
		art.rotation = dir.angle()
		puck.add_child(art)
	get_parent().add_child(puck)
	pucks.append(puck)
	pucks_fired += 1
	shooting = true


func reset_play_state() -> void:
	_last_index = -1
	pucks_fired = 0
	shooting = false
	for p in pucks:
		if is_instance_valid(p):
			p.queue_free()
	pucks.clear()
	super()
