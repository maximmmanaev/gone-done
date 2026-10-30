# Каркас из AutoDoor.cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Автодверь: по таймеру (режим timed) открывается и закрывается; закрывшись на персонаже, убивает его через door_hazard_delay.
class_name AutoDoor
extends ActiveBlock

@export var interval: float = 2.0            # GUESS
@export var door_hazard_delay: float = 0.2   # C# DoorHazardDelay (значение GUESS)
@export var timed := true                    # C# timed; режим «по движению» не переносился
var timer := 0.0
var open := false
var hazard_timer := 0.0
var trapped: Array = []   # кто был в проёме, когда дверь закрылась (физика выталкивает их из зоны, но опасность остаётся)
var body: StaticBody2D
var collider: CollisionShape2D
var _visual_alpha := 1.0


func setup_body(b: StaticBody2D, size: Vector2) -> void:
	body = b
	for ch in b.get_children():
		if ch is CollisionShape2D:
			collider = ch
	# зона чуть меньше двери: в ней оказывается только тот, на ком дверь закрылась
	setup_zone(size - Vector2(4, 4))


func _set_open(value: bool) -> void:
	open = value
	hazard_timer = 0.0
	trapped = [] if value else zone_characters.filter(func(c): return is_instance_valid(c))
	if collider != null:
		collider.set_deferred("disabled", value)
	if body != null:
		body.modulate.a = 0.25 if value else 1.0


func act(delta: float) -> void:
	if timed:
		timer += delta
		if timer >= interval:
			timer -= interval
			_set_open(not open)
	if open:
		return
	trapped = trapped.filter(func(c): return is_instance_valid(c) and not c.dead and not c.dying)
	if trapped.is_empty():
		hazard_timer = 0.0
		return
	hazard_timer += delta
	if hazard_timer >= door_hazard_delay:
		for c: Character in trapped:
			c.kill_character("door", self)
		trapped = []


func reset_play_state() -> void:
	timer = 0.0
	_set_open(false)
	trapped = []
	if collider != null:
		collider.disabled = false
	super()
