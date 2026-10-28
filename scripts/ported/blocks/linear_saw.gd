# Каркас из structur/LinearSaw.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name LinearSaw
extends ActiveBlock

var anim: AnimationPlayer
@export var saw_blade: CollisionShape2D
@export var saw_move_speed: float = 48.0
@export var spinner: Node2D
@export var linear_saw_sound_event: String


func activate_sound() -> void:  # C# activateSound
	pass

func act(delta_time: float) -> void:  # C# Act
	if spinner:
		spinner.rotation += 10.0 * delta_time
	amount_moved += saw_move_speed * delta_time * _sign
	if amount_moved >= travel_distance:
		amount_moved = travel_distance
		_sign = -1.0
	elif amount_moved <= 0.0:
		amount_moved = 0.0
		_sign = 1.0
	position = start_origin + travel_dir.normalized() * amount_moved
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.kill_character(kill_type if kill_type != "" else "saw")

var travel_dir := Vector2.RIGHT
var travel_distance := 64.0
var blade_size := Vector2(20, 20)
var start_origin := Vector2.ZERO
var amount_moved := 0.0
var _sign := 1.0


func _ready() -> void:
	start_origin = position
	setup_zone(blade_size)
