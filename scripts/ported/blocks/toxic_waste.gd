# Каркас из structur/ToxicWaste.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name ToxicWaste
extends ActiveBlock

static var in_gameplay: int
var animator: AnimationPlayer
var all_animators: Array
var toxic_pool_manager: ToxicPoolManager

func _ready() -> void:
	setup_zone(Vector2(32, 16))


func act(_delta: float) -> void:
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.kill_character(kill_type if kill_type != "" else "toxic")
