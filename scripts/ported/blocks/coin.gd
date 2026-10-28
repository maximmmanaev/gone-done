# Каркас из structur/Coin.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Coin
extends ActiveBlock

@export var coin_holder: Node2D
@export var return_to_holder_time: float = 1.0
@export var coin_follow_distance: float = 14.0
var coin_follow_speed: Curve
var carrier: Character
var start_position: Vector3
var random_extra_distance: float
var at_spawn_point: bool
var awarded: bool
var coin_moving: bool
var pickup_requested: bool
var pickup_requester: Character
var animator: AnimationPlayer
@export var coin_effect: Node2D
var last_surrogate_int: int
var skip_move: bool
@export var coin_pick_up_sfx: String
@export var force_always_respawn: bool
var always_respawn: bool  # C# property

func _ready() -> void:  # C# Start
	start_position = Vector3(global_position.x, global_position.y, 0.0)
	at_spawn_point = true
	setup_zone(Vector2(14, 14))

func _process(delta: float) -> void:  # C# Update
	if not is_instance_valid(carrier):
		carrier = null
		return
	if carrier.dying or carrier.dead:
		drop(carrier.global_position, true)
	elif carrier.success:
		do_award_animation()
	else:
		var target := carrier.global_position + Vector2(-carrier.facing * coin_follow_distance, -16.0)
		global_position = global_position.lerp(target, clampf(12.0 * delta, 0.0, 1.0))

func drop(coin_position: Vector2, return_to_respawn: bool) -> void:  # C# Drop
	carrier = null
	global_position = coin_position
	coin_moving = false
	if return_to_respawn or always_respawn or force_always_respawn:
		return_coin_to_spawn()

func do_award_animation() -> void:  # C# DoAwardAnimation
	if awarded or carrier == null:
		return
	awarded = true
	carrier.coins_collected += 1
	coin_moving = false
	visible = false




func pickup(chr: Character) -> void:  # C# Pickup
	carrier = chr
	at_spawn_point = false
	coin_moving = true
	pickup_requester = chr


func return_coin_to_spawn():  # C# returnCoinToSpawn (coroutine)
	carrier = null
	global_position = Vector2(start_position.x, start_position.y)
	at_spawn_point = true
	coin_moving = false



static func get_coin_from_surrogate_id(id) -> Coin:  # C# GetCoinFromSurrogateID
	return null

func set_carrier(chr: Character) -> void:  # C# SetCarrier
	carrier = chr

func handle_event(e) -> void:  # C# handleEvent
	pass

func enable_placed() -> void:  # C# EnablePlaced
	pass

func on_character_entered(c: Character) -> void:
	if carrier == null and not awarded and not c.dead and not c.dying:
		pickup(c)
