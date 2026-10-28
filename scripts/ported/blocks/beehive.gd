# Ported from structur/Beehive.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Beehive
extends ActiveBlock

enum BeeState {
	INACTIVE,
	SWARM,
	POSTSWARM,
	DISAPPEAR,
	WALKONHIVE,
}
var followed_character: Character
var bees: BeeSwarm
@export var bee_hazard: CollisionShape2D
@export var indicator_bees: Node2D
@export var animator: AnimationPlayer
@export var birth_time: float
@export var bee_speed: float
@export var return_bee_speed: float
var attack_dead_body_timer: float
@export var attack_dead_body_time: float
var bee_death_anim
var bee_birth_anim
var bees_requested: bool
var bees_moving: bool
var bees_unleashed: bool
@export var follow_bee_accel: float
var follow_bee_acceleration_distance_modifier: Curve
var follow_bee_distance_to_clump_random_noise_mod: Curve
var follow_bee_curve: Curve
@export var velocity_dampening_friction: float
@export var follow_bees: Node2D
var bee_transforms: Array
var last_bee_force: Array
var follow_bees_velocity: Array
var random_heading: Array
var random_magnitude: Array
var bee_state: Array
var bee_history: Array
var bee_history_max_size: int
var bee_history_current_index: int
@export var noise_temporal_speed_heading: float
@export var noise_temporal_speed_magnitude: float
@export var bee_spawn_point: Node2D
@export var random_offset_fluctuation_rate: float
@export var random_heading_speed: float
var heading_speed_through_swarm: Curve
@export var target_modifier_speed: float
@export var post_swarm_random_heading_speed: float
@export var post_swarm_random_friction: float
var disappear_bee_acceleration_index_modifier: Curve
var disappear_bee_distance_to_clump_random_noise_mod: Curve
var disappear_bee_spring_speed: Curve
@export var return_random_heading_speed: float
@export var return_target_modifier_speed: float
@export var indicator_bee_num: int
@export var bee_walk_point: Node2D
@export var bee_walk_speed: float
@export var bee_walk_random_speed: float
@export var bee_walk_friction: float
@export var bee_walktemporal_noise_speed: float
@export var bee_walk_minimum_random_magnitude: float
var walking_bee_acceleration_distance_modifier: Curve
@export var random_rate_of_return_to_hive: int
@export var random_rate_of_post_swarm: int
var target_position: Vector3

func _ready() -> void:  # C# Start
	pass

func set_followed_character(character: Character) -> void:  # C# SetFollowedCharacter
	pass

func enable_0() -> void:  # C# Enable
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func place_1(player_number: int) -> void:  # C# Place
	pass

func do_place() -> void:  # C# doPlace
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func animate_bee_death() -> void:  # C# AnimateBeeDeath
	pass

func bee_death_animation():  # C# BeeDeathAnimation (coroutine)
	pass

func animate_bee_birth() -> void:  # C# AnimateBeeBirth
	pass

func bee_birth_animation():  # C# BeeBirthAnimation (coroutine)
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

static func get_beehive_from_surrogate_id(id) -> Beehive:  # C# GetBeehiveFromSurrogateID
	return null

func bee_past_position(frames_in_past: int) -> Vector3:  # C# BeePastPosition
	return Vector3.ZERO

func _exit_tree() -> void:  # C# OnDestroy
	pass
