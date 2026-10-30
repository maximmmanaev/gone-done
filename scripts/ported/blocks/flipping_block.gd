# Каркас из оригинального .cs + логика, написанная вручную (константы в декомпиляции потеряны, помечены GUESS). Конвертер этот файл не трогает.
## Переворачивающийся блок: каждые interval меняет сторону — безопасная платформа или шипами вверх (убивает тех, кто на нём).
class_name FlippingBlock
extends ActiveBlock

@export var interval: float = 2.0     # C# Interval (значение GUESS)
var solid := true                     # C# solid: true — безопасная сторона сверху
var timer := 0.0
var body: StaticBody2D


func setup_body(b: StaticBody2D, size: Vector2) -> void:
	body = b
	setup_zone(Vector2(size.x - 2.0, 6.0), Vector2(0, -size.y / 2.0 - 3.0))


func _set_solid(value: bool) -> void:
	solid = value
	if body != null:
		body.modulate = Color.WHITE if value else Color(1.0, 0.45, 0.45)
		body.scale.y = 1.0 if value else 1.0


func act(delta: float) -> void:
	timer += delta
	if timer >= interval:
		timer -= interval
		_set_solid(not solid)
	if not solid:
		for c: Character in zone_characters:
			if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost:
				c.kill_character("spikes", self)


func reset_play_state() -> void:
	timer = 0.0
	_set_solid(true)
	super()
