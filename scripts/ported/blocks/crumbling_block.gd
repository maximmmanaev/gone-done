# Каркас из CrumblingBlock.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Хрупкий блок: твёрдый, пока на нём стоят меньше fall_delay; потом падает, через collider_off_delay теряет коллайдер и исчезает.
class_name CrumblingBlock
extends ActiveBlock

@export var fall_delay: float = 0.2          # C# fallDelay = 0.2f
@export var collider_off_delay: float = 0.15 # GUESS
@export var gravity_value: float = 700.0     # GUESS
@export var gravity_floor: float = 420.0     # GUESS: предельная скорость падения
@export var fade_time: float = 0.5           # GUESS
var collided: bool
var collide_time := -1.0
var falling: bool
var velocity_y := 0.0
var fall_time := 0.0
var body: StaticBody2D
var collider: CollisionShape2D
var _start := Vector2.ZERO


## body — твёрдая платформа, которую обрушиваем; size — её размер в пикселях.
func setup_body(b: StaticBody2D, size: Vector2) -> void:
	body = b
	collider = b.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collider == null:
		for ch in b.get_children():
			if ch is CollisionShape2D:
				collider = ch
	_start = b.position
	setup_zone(Vector2(size.x - 2.0, 6.0), Vector2(0, -size.y / 2.0 - 3.0))


func act(delta: float) -> void:
	if falling:
		fall_time += delta
		velocity_y = minf(velocity_y + gravity_value * delta, gravity_floor)
		body.position.y += velocity_y * delta
		if fall_time >= collider_off_delay and collider != null and not collider.disabled:
			collider.set_deferred("disabled", true)
		body.modulate.a = clampf(1.0 - maxf(fall_time - collider_off_delay, 0.0) / fade_time, 0.0, 1.0)
		if body.modulate.a <= 0.0:
			body.visible = false
		return
	var touched := false
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
			touched = true
	if touched and collide_time < 0.0:
		collided = true
		collide_time = 0.0
	if collide_time >= 0.0:
		collide_time += delta
		if collide_time >= fall_delay:
			falling = true


func reset_play_state() -> void:
	falling = false
	collided = false
	collide_time = -1.0
	velocity_y = 0.0
	fall_time = 0.0
	if body != null:
		body.position = _start
		body.modulate.a = 1.0
		body.visible = true
	if collider != null:
		collider.set_deferred("disabled", false)
	super()
