# Каркас из structur/Projectile.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Projectile
extends Node2D

@export var direction: Vector2
var images: Array
@export var speed: float = 230.0
var kill_boundary: AABB
@export var lifespan: float = 6.0
@export var use_gravity: bool
@export var u_gravity_scale: float
@export var rotate_to_angle: bool
@export var angle_friction_factor: float
@export var auto_rotate_delay: float
@export var collided: bool
@export var hit_sound_event: String
@export var hit_sound_event_player: String
@export var attach_on_hit: bool
var pause_vel: Vector3
var initial_position: Vector3
var initial_rotation: Quaternion
var initial_scale: Vector3
@export var collided_with_object: Node2D
@export var debris: Node2D
@export var hit_player_debris: Node2D
var launched_from: ProjectileLauncher
@export var sprite_renderer: Sprite2D
@export var penetration_depth: float
@export var push_character_strength: float
@export var random_hit_target_range: float
@export var time_of_penetration_ease: float
var time_alive: float
var scoreboard: bool
@export var placed_by_player_number: int
var animator: AnimationPlayer
var last_exited_teleporter: Teleporter
@export var max_linear_speed: float
@export var head_on_aerodynamism_factor: float
@export var side_aerodynamism_factor: float
@export var moving_platform: bool
@export var destroyed_by_attractor_repulsor: bool
@export var projectile_number: int
var broad_cast_destructions: bool
@export var board_cast_random_hits: bool
@export var collision_indicator: Node2D
var crashing: bool
@export var raycast_origin: Node2D
@export var destroyed_by_other_projectiles: bool
var src_pool: ObjPool
static var solid_player_mask
static var player_body_mask
static var attractor_repulsor_layer: int
var paused: bool  # C# property


func launch() -> void:  # C# Launch
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass


func get_z_rot_for_velocity(vel: Vector3) -> float:  # C# GetZRotForVelocity
	return 0.0

func soft_rotate_to_target(target_rot: float, inverse_time: float) -> void:  # C# SoftRotateToTarget
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func signal_destructions() -> void:  # C# SignalDestructions
	pass

func crash() -> void:  # C# Crash
	pass

func start_unstable_crash() -> void:  # C# StartUnstableCrash
	pass

func projectile_trigger_1(collider: CollisionShape2D) -> void:  # C# ProjectileTrigger
	pass

func modify_lifespan(percent: float) -> void:  # C# ModifyLifespan
	pass

var area: Area2D


func _enter_tree() -> void:
	area = Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 3          # мир (1) и игрок (2)
	area.monitorable = false
	var shape := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(3, 11)
	shape.shape = rs
	area.add_child(shape)
	area.body_entered.connect(_on_hit)
	add_child(area)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	time_alive += delta
	if time_alive >= lifespan:
		queue_free()


func _on_hit(body: Node) -> void:
	if collided:
		return
	if body is Character:
		body.kill_character("arrow", launched_from)
		collided = true
		queue_free()
	elif body is PhysicsBody2D:
		collided = true      # воткнулась в крышу или блок
		queue_free()
