# Каркас из structur/Blackhole.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Blackhole
extends ActiveBlock

@export var pull_strength: float = 5000.0
var gravity_curve: Curve
@export var shrink_time: float
@export var death_distance: float = 10.0
@export var rotate_spin_speed: float = 4.0
@export var kill_offset: Vector3
@export var cutoff_distance_sqr: float
@export var death_cause_name: String
@export var blackhole_burst_prefab: Node2D
var current_blackhole_burst: blackholeBurst
@export var blackhole_burst_filled: bool
@export var blackhole_burst_timer: float
@export var blackhole_burst_time: float
var currently_sucking: Array
var animator: AnimationPlayer

func _ready() -> void:  # C# Start
	setup_zone(Vector2.ONE * pull_radius * 2.0)


func _physics_process(delta: float) -> void:  # C# FixedUpdate
	super(delta)
	if not is_active or paused or not is_live():
		return
	for c: Character in zone_characters:
		if not is_instance_valid(c) or c.dead or c.is_ghost:
			continue
		var to_center := global_position - c.global_position
		var dist := to_center.length()
		if dist < death_distance:
			c.kill_character(death_cause_name if death_cause_name != "" else "blackhole", self)
			continue
		var atten := clampf(1.0 - dist / pull_radius, 0.0, 1.0)
		var pull := to_center / dist * pull_strength * atten
		c.wind_x = pull.x
		c.wind_y = pull.y

func suck_in_character(chr: Character):  # C# suckInCharacter (coroutine)
	if not currently_sucking.has(chr):
		currently_sucking.append(chr)

var pull_radius := 56.0


func on_character_entered(c: Character) -> void:
	suck_in_character(c)


func on_character_exited(c: Character) -> void:
	currently_sucking.erase(c)
	c.wind_x = 0.0
	c.wind_y = 0.0


func reset_play_state() -> void:
	currently_sucking.clear()
