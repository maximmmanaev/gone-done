# Каркас из structur/WindArea.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name WindArea
extends Node2D

enum OperationMode {
	Wind,
	Blackhole,
}
var operation_mode = OperationMode.Wind
var pause_wind: bool
@export var blow_direction: Vector2 = Vector2.UP
@export var projectile_blow_power: float = 400.0
@export var gravity_projectile_use_alternate_blow_power: bool
@export var projectile_blow_power_against_gravity: float
@export var character_blow_power: float = 1600.0
var black_hole_distance_attenuation: Curve
@export var blackhole_center: Node2D
var affected_characters: Array
var affected_projectiles: Array
var destroyed_projectiles: Array

func _ready() -> void:  # C# Start
	area = Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitorable = false
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = area_size
	shape.shape = rect
	area.add_child(shape)
	area.body_entered.connect(_body_entered)
	area.body_exited.connect(_body_exited)
	add_child(area)

func _exit_tree() -> void:  # C# OnDestroy
	for c: Character in affected_characters:
		if is_instance_valid(c):
			c.wind_x = 0.0
			c.wind_y = 0.0
	affected_characters.clear()

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	if pause_wind:
		return
	for c: Character in affected_characters:
		if not is_instance_valid(c) or c.dead or c.is_ghost:
			continue
		if operation_mode == OperationMode.Blackhole:
			var center := blackhole_center.global_position if blackhole_center else global_position
			var to_center := center - c.global_position
			var dist := to_center.length()
			var radius := maxf(area_size.x, area_size.y) * 0.5
			var atten := clampf(1.0 - dist / radius, 0.0, 1.0)
			if black_hole_distance_attenuation:
				atten = black_hole_distance_attenuation.sample(atten)
			var pull := to_center.normalized() * character_blow_power * atten
			c.wind_x = pull.x
			c.wind_y = pull.y
			if dist < kill_radius:
				c.kill_character("blackhole", self)
		else:
			var push := blow_direction.normalized() * character_blow_power
			c.wind_x = push.x
			c.wind_y = push.y

func handle_event(e) -> void:  # C# handleEvent
	pass

var area: Area2D
var area_size := Vector2(64, 64)
var kill_radius := 6.0


func _body_entered(body: Node) -> void:
	if body is Character and not affected_characters.has(body):
		affected_characters.append(body)


func _body_exited(body: Node) -> void:
	if body is Character:
		affected_characters.erase(body)
		body.wind_x = 0.0
		body.wind_y = 0.0
