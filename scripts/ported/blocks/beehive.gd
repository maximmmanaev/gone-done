# Каркас из Beehive.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Улей: через birth_time выпускает рой; рой догоняет ближайшего персонажа, убивает при касании и возвращается домой.
class_name Beehive
extends ActiveBlock

@export var birth_time: float = 1.0           # C# birthTime (значение GUESS)
@export var bee_speed: float = 70.0           # C# beeSpeed (GUESS): медленнее бега 115, от роя можно убежать
@export var return_bee_speed: float = 90.0    # C# returnBeeSpeed (GUESS)
@export var follow_bee_accel: float = 240.0   # C# followBeeAccel (GUESS)
@export var sight_range: float = 260.0        # GUESS
@export var kill_distance: float = 11.0       # GUESS
@export var attack_dead_body_time: float = 0.6   # C# attackDeadBodyTime (GUESS): пауза после убийства
var followed_character: Character
var swarm: BeeSwarm
var unleashed := false
var _age := 0.0
var _vel := Vector2.ZERO
var _pause := 0.0


func _ready() -> void:
	swarm = BeeSwarm.new()
	swarm.home_hive = self
	add_child(swarm)


func act(delta: float) -> void:
	_age += delta
	if _age < birth_time:
		return
	unleashed = true
	_pause = maxf(_pause - delta, 0.0)
	followed_character = _nearest_target()
	if followed_character != null and _pause <= 0.0:
		var want := (followed_character.global_position - swarm.global_position)
		_vel = (_vel + want.normalized() * follow_bee_accel * delta).limit_length(bee_speed)
		swarm.global_position += _vel * delta
		if swarm.global_position.distance_to(followed_character.global_position) <= kill_distance:
			followed_character.kill_character("bees", self)
			_pause = attack_dead_body_time
			_vel = Vector2.ZERO
	else:
		var home := global_position - swarm.global_position
		var step := return_bee_speed * delta
		_vel = Vector2.ZERO
		swarm.global_position += home if home.length() <= step else home.normalized() * step


func _nearest_target() -> Character:
	var best: Character = null
	var best_d := sight_range
	for c: Character in Character.all_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost and not c.success:
			var d := c.global_position.distance_to(swarm.global_position)
			if d < best_d:
				best_d = d
				best = c
	return best


func reset_play_state() -> void:
	_age = 0.0
	unleashed = false
	followed_character = null
	_vel = Vector2.ZERO
	_pause = 0.0
	if swarm != null:
		swarm.position = Vector2.ZERO
	super()
