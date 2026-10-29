# Каркас из structur/Boulder.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Boulder
extends ActiveBlock

var animator: AnimationPlayer

func _ready() -> void:  # C# Start
	start_origin = position
	setup_zone(body_size)

func trigger_trap() -> void:  # C# TriggerTrap
	if rolling or spent:
		return
	rolling = true



func play_bounce_sound() -> void:  # C# playBounceSound
	pass

var roll_dir := Vector2.RIGHT
var roll_speed := 140.0
var roll_distance := 128.0
var trigger_range := 96.0
var body_size := Vector2(28, 28)
var rolling := false
var spent := false
var start_origin := Vector2.ZERO
var _travelled := 0.0


func act(delta: float) -> void:
	if not rolling:
		for c: Character in Character.all_characters:
			if is_instance_valid(c) and not c.dead and not c.is_ghost:
				var rel := c.global_position - global_position
				if rel.dot(roll_dir) > 0.0 and rel.dot(roll_dir) < trigger_range and absf(rel.cross(roll_dir)) < 32.0:
					trigger_trap()
		return
	var step := roll_speed * delta
	position += roll_dir * step
	_travelled += step
	rotation += step / 14.0
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.kill_character("boulder", self)
	if _travelled >= roll_distance:
		rolling = false
		spent = true


func reset_play_state() -> void:
	rolling = false
	spent = false
	_travelled = 0.0
	position = start_origin
	rotation = 0.0
