# Ported from structur/FallingIce.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FallingIce
extends Node2D

@export var direction: Vector2
var images: Array
@export var speed: float
@export var rotate_speed: float
var kill_boundary: AABB
@export var lifespan: float
@export var use_gravity: bool
@export var u_gravity_scale: float
var collided: bool
@export var hit_sound_event: String
@export var hit_sound_event_player: String
var pause_vel: Vector3
@export var collided_with_object: Node2D
@export var debris: Node2D
@export var sprite_renderer: Sprite2D
var time_alive: float
var scoreboard: bool
@export var placed_by_player_number: int
@export var not_deadly_time: float
static var solid_player_mask
static var trigger_check_mask
static var trigger_ignore_mask
var paused: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass

func is_solid_player(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsSolidPlayer
	return false

func collides_with_trigger(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# CollidesWithTrigger
	return false

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
