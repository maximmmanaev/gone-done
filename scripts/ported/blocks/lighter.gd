# Каркас из structur/Lighter.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Lighter
extends ActiveBlock

@export var animator: AnimationPlayer
@export var fire_hazard: CollisionShape2D
@export var interval: float = 3.4
var timer: float
var lighter_on: bool
@export var dial_holder: Node2D

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	var on := fmod(play_clock() + phase, interval) < on_time
	if on != lighter_on:
		set_lighter_hazard_state(on)
	if lighter_on:
		for c: Character in zone_characters:
			if is_instance_valid(c):
				c.kill_character("fire", self)

func set_lighter_hazard_state(on_off: bool) -> void:  # C# SetLighterHazardState
	lighter_on = on_off
	if flame_node:
		flame_node.visible = on_off

var on_time := 1.2
var phase := 0.0
var flame_node: Node2D = null     # картинка огня; включается вместе с опасной зоной


func reset_play_state() -> void:
	set_lighter_hazard_state(false)
