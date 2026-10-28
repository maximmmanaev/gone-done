# Каркас из structur/SwingingAxe.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name SwingingAxe
extends ActiveBlock

var anim: AnimationPlayer
@export var saw_move_speed: float = 2.0
@export var rotate_locked: Node2D
@export var linear_saw_sound_event: String



func activate_sound() -> void:  # C# activateSound
	pass

func act(delta_time: float) -> void:  # C# Act
	_t += delta_time * saw_move_speed
	var pivot: Node2D = rotate_locked if rotate_locked else self
	pivot.rotation = amplitude * sin(_t)
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.kill_character(kill_type if kill_type != "" else "axe")

var amplitude := 1.0           # размах качания, рад
var axe_length := 40.0
var axe_head_size := Vector2(24, 24)
var _t := 0.0


func _ready() -> void:
	var z := setup_zone(axe_head_size, Vector2(0, axe_length))
	if rotate_locked:
		remove_child(z)
		rotate_locked.add_child(z)
