# Ported from structur/HockeyShooter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name HockeyShooter
extends ActiveBlock

var puck_streak
var puck_sprite
@export var initial_delay: float
@export var interval: float
var mod_interval: float
@export var angle: float
@export var last_shot: float
@export var sound_event_name: String
var anim: AnimationPlayer
@export var shooting: bool
@export var ray_start: Node2D
@export var ray_end: Node2D
@export var ray_start_debug: Vector3
@export var ray_end_debug: Vector3
@export var push_character_strength: float
var add_impulse_switch: bool
var impulse_to_add: Vector2
var impulse_target: Character
@export var vertical_push_extra: float
var puck_interacts_layers
@export var boxcast_size: Vector2
var last_traversed_teleporter: Teleporter
var last_shot_cannon: AnimalCannon
@export var impact_projectile_trigger: Node2D
var impact_projectile_trigger_animator
@export var puck_sprite_sorting_layer_name: String
@export var puck_sprite_sorting_order: int
static var puck_sprite_sorting_layer_id: int

func _ready() -> void:  # C# Start
	pass

func update_initial_delay() -> void:  # C# UpdateInitialDelay
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func activate_0() -> void:  # C# Activate
	pass

func shoot_projectile_0() -> void:  # C# ShootProjectile
	pass

func throw_puck(ray_start: Vector3, ray_dir: Vector3, recursions: int) -> void:  # C# ThrowPuck
	pass

func do_redirect(ray_start: Vector3, ray_end: Vector3, recursions: int) -> bool:  # C# doRedirect
	return false

func teleport_puck(ray_dir: Vector3, teleporter_hit_point: Vector3, found_teleporter: Teleporter, recursions: int) -> void:  # C# TeleportPuck
	pass

func shoot_puck(ray_dir: Vector3, cannon_hit_point: Vector3, found_cannon: AnimalCannon, recursions: int) -> void:  # C# ShootPuck
	pass

func find_teleporter(p_0: Vector3, dir: Vector2, hit_point: Vector3) -> Teleporter:  # C# FindTeleporter
	return null

func find_animal_cannon(p_0: Vector3, dir: Vector2, hit_point: Vector3) -> AnimalCannon:  # C# FindAnimalCannon
	return null

func make_streak(streak_start_position: Vector3, puck_hit_position: Vector3, puck_hit_normal: Vector3, show_puck: bool) -> Node2D:  # C# MakeStreak
	return null

func warning_sound() -> void:  # C# warningSound
	pass

func shooting_sound() -> void:  # C# shootingSound
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func show_projectile_trigger(impact_position: Vector3) -> void:  # C# ShowProjectileTrigger
	pass

func hide_projectile_trigger() -> void:  # C# HideProjectileTrigger
	pass

func hide_projectile_trigger_after(frames: int):  # C# HideProjectileTriggerAfter (coroutine)
	pass
