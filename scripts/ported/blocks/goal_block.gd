# Каркас из structur/GoalBlock.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name GoalBlock
extends Placeable

var spectator_positions: Array

func _ready() -> void:
	setup_zone(Vector2(16, 32))


func on_character_entered(c: Character) -> void:
	if not c.dead and not c.dying:
		c.set_success(true)
