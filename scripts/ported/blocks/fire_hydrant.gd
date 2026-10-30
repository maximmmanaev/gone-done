# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Пожарный гидрант: каждые interval за rise_time выбрасывает столб воды высотой rise_height, держит on_time и опускает за fall_time; столб несёт вверх.
class_name FireHydrant
extends ActiveBlock

@export var interval: float = 3.0         # C# Interval (значение GUESS)
@export var rise_time: float = 0.4        # C# riseTime (GUESS)
@export var fall_time: float = 0.4        # C# fallTime (GUESS)
@export var on_time: float = 1.2          # GUESS
@export var rise_height: float = 80.0     # C# riseHeight (GUESS)
@export var lift_speed: float = 190.0     # GUESS
@export var lift_accel: float = 1100.0    # GUESS
var timer := 0.0
var on := false
var height := 0.0
var geyser_visual: Node2D
var _base_size := Vector2(16, 16)


func setup_geyser(size: Vector2) -> void:
	_base_size = size
	setup_zone(Vector2(size.x, 1.0), Vector2(0, -size.y / 2.0))
	_apply_height(0.0)


func _apply_height(h: float) -> void:
	height = h
	if zone != null and zone.get_child_count() > 0:
		var shape := zone.get_child(0) as CollisionShape2D
		(shape.shape as RectangleShape2D).size = Vector2(_base_size.x, maxf(h, 1.0))
		shape.position = Vector2(0, -_base_size.y / 2.0 - h / 2.0)
	if geyser_visual != null:
		geyser_visual.scale.y = maxf(h / maxf(rise_height, 1.0), 0.001)
		geyser_visual.visible = h > 1.0


func act(delta: float) -> void:
	timer += delta
	var cycle := interval + rise_time + on_time + fall_time
	var t := fmod(timer, cycle)
	var h := 0.0
	if t < interval:
		h = 0.0
	elif t < interval + rise_time:
		h = rise_height * (t - interval) / maxf(rise_time, 0.001)
	elif t < interval + rise_time + on_time:
		h = rise_height
	else:
		h = rise_height * (1.0 - (t - interval - rise_time - on_time) / maxf(fall_time, 0.001))
	on = h > 1.0
	_apply_height(h)
	if on:
		for c: Character in zone_characters:
			if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
				c.velocity.y = move_toward(c.velocity.y, -lift_speed, lift_accel * delta)


func reset_play_state() -> void:
	timer = 0.0
	on = false
	_apply_height(0.0)
	super()
