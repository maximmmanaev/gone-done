# Каркас из PunchingBlock.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Боксирующий блок: кто наступил на верх (триггер), того, кто стоит перед перчаткой, она отбрасывает; не убивает.
class_name PunchingBlock
extends ActiveBlock

const PROJECTILE_GRACE_TIME: float = 0.5   # C# projectileGraceTime
@export var punch_strength: float = 330.0  # GUESS
@export var punch_lift: float = 90.0       # GUESS: небольшой подброс
@export var punch_time: float = 0.25       # GUESS
@export var cooldown: float = 0.6          # GUESS
@export var reach: float = 14.0            # GUESS: на сколько выезжает перчатка
var dir := Vector2.RIGHT
var punching: bool
var trigger_touched: bool
var projectile_grace_timer := 0.0
var body: StaticBody2D
var glove: Node2D
var glove_base := Vector2.ZERO
var push_area: Area2D
var _t := 0.0
var _cool := 0.0
var _pushed: Array = []


func setup_body(b: StaticBody2D, size: Vector2) -> void:
	body = b
	setup_zone(Vector2(size.x - 2.0, 6.0), Vector2(0, -size.y / 2.0 - 3.0))   # кнопка на верхней грани
	var half := size.x / 2.0 if dir.x != 0.0 else size.y / 2.0
	push_area = Area2D.new()
	push_area.collision_layer = 0
	push_area.collision_mask = PLAYER_LAYER
	push_area.monitorable = false
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(reach + 10.0, size.y + 8.0) if dir.x != 0.0 else Vector2(size.x + 8.0, reach + 10.0)
	shape.shape = rect
	shape.position = dir * (half + (reach + 10.0) / 2.0)
	push_area.add_child(shape)
	add_child(push_area)


func on_trigger_touched() -> void:   # C# OnTriggerTouched
	trigger_touched = true


func act(delta: float) -> void:
	_cool = maxf(_cool - delta, 0.0)
	projectile_grace_timer = maxf(projectile_grace_timer - delta, 0.0)
	var stepped := false
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
			stepped = true
	if stepped:
		on_trigger_touched()
	if trigger_touched and not punching and _cool <= 0.0:
		punch(true)
	trigger_touched = false
	if not punching:
		return
	_t += delta
	if glove != null:
		glove.position = glove_base + dir * reach * sin(clampf(_t / punch_time, 0.0, 1.0) * PI)
	if _t >= 0.1 * punch_time:   # удар приходится на начало выезда
		_push()
	if _t >= punch_time:
		punching = false
		_cool = cooldown
		_pushed.clear()
		if glove != null:
			glove.position = glove_base


func punch(_locally_triggered: bool) -> void:   # C# Punch
	punching = true
	_t = 0.0
	projectile_grace_timer = PROJECTILE_GRACE_TIME
	_pushed.clear()


func _push() -> void:
	if push_area == null:
		return
	for b in push_area.get_overlapping_bodies():
		if b is Character and not _pushed.has(b) and not b.dead and not b.dying:
			_pushed.append(b)
			b.add_impulse(dir * punch_strength + Vector2(0, -punch_lift))


func reset_play_state() -> void:
	punching = false
	trigger_touched = false
	_t = 0.0
	_cool = 0.0
	_pushed.clear()
	if glove != null:
		glove.position = glove_base
	super()
