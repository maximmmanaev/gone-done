# Каркас из AttractorRepulsor.cs + логика, написанная вручную.
## Магнит тянет к центру; обратный поворот переключает его на отталкивание.
class_name AttractorRepulsor
extends ActiveBlock

@export var radius := 72.0         # GUESS
@export var push_accel := 480.0    # GUESS
var repels := false


func act(delta: float) -> void:
	for c: Character in zone_characters:
		if not is_instance_valid(c) or c.dead or c.dying or c.success or c.is_ghost:
			continue
		var offset := global_position - c.global_position
		var weight := clampf(1.0 - offset.length() / radius, 0.0, 1.0)
		var force := offset.normalized() * push_accel * weight * delta
		c.add_impulse(-force if repels else force)
