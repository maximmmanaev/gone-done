# Ported from structur/AnimalCannon.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AnimalCannon
extends ActiveBlock

@export var cannon_animator: AnimationPlayer
@export var launch_target: Node2D
@export var smoke_transform: Node2D
@export var blur_transform: Node2D
@export var default_smoke_color: Color
@export var time_to_launch: float
@export var launch_anticipation: float
var chrs_in_cannon_data: Dictionary
var chrs_to_remove_from_cannon: Array
static var all_animal_cannon: Array
var net_surrogate_launch_int: int
@export var booster_center: Node2D
var tracked_projectiles: Array
var cool_downs: Dictionary
var cool_downs_to_remove: Array
@export var boost_cooldown_time: float
@export var boost_radius: float
@export var boost_character_strength: float
@export var boost_projectile_strength: float
@export var boost_angle: float
var next_smoke_color: Color
var facing_direction: int

func _enter_tree() -> void:  # C# Awake
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func process_chrs_in_cannon() -> void:  # C# ProcessChrsInCannon
	pass

func is_player(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsPlayer
	return false

func is_body(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsBody
	return false

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func destroy_self_3(destroy_children: bool, use_smoke: bool, send_network_signal: bool) -> void:  # C# DestroySelf
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func cancel_launch() -> void:  # C# CancelLaunch
	pass

func remove_character_from_cannon(chr: Character) -> void:  # C# RemoveCharacterFromCannon
	pass

static func on_character_respawned(chr: Character) -> void:  # C# OnCharacterRespawned
	pass

func shoot_character(character: Character) -> void:  # C# ShootCharacter
	pass

func smook_poof_spawn() -> void:  # C# SmookPoofSpawn
	pass

func on_projectile_enter_trigger(collision: CollisionShape2D) -> void:  # C# OnProjectileEnterTrigger
	pass

func on_projectile_exit_trigger(collision: CollisionShape2D) -> void:  # C# OnProjectileExitTrigger
	pass

func shoot_projectile_1(projectile: Projectile) -> void:  # C# ShootProjectile
	pass

func get_cooldown_time(obj: Node2D) -> float:  # C# GetCooldownTime
	return 0.0
