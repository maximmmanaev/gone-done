# Каркас из structur/Spring.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Spring
extends Placeable

var trigger: CheckColliding
@export var strength: float = 410.0
@export var direction: Vector2 = Vector2.UP
@export var spring_animator: AnimationPlayer
var last_pushed: Dictionary
const PUSH_DELAY: float = 0.2

func _ready() -> void:  # C# Start
	setup_zone(Vector2(16, 8), direction.normalized() * 8.0)

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	super(delta)
	if not is_live():
		return
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.is_ghost and clock - last_pushed.get(c, -INF) >= PUSH_DELAY:
			last_pushed[c] = clock
			c.bounce(strength, direction.normalized())

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass

func on_collision_stay_2d(c) -> void:  # C# OnCollisionStay2D
	pass

func on_character_exited(c: Character) -> void:
	last_pushed.erase(c)
