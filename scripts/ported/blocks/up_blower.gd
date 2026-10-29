# Каркас из structur/UpBlower.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name UpBlower
extends ActiveBlock

var blow_dir := Vector2.UP
var blow_power := 1300.0
var top_speed := 200.0


func act(_delta: float) -> void:
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.is_ghost:
			c.wind_x = blow_dir.x * blow_power
			c.wind_y = blow_dir.y * blow_power
			var along := c.velocity.dot(blow_dir)
			if along > top_speed:
				c.velocity -= blow_dir * (along - top_speed)


func on_character_entered(_c: Character) -> void:
	pass


func on_character_exited(c: Character) -> void:
	c.wind_x = 0.0
	c.wind_y = 0.0
