# Ported from structur/CharacterRaycaster.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CharacterRaycaster
extends Node2D

var character: Character
@export var raycast_start_anchor: Node2D
@export var raycast_end_anchor: Node2D
@export var raycast_direction: Vector3
@export var raycast_length: float
@export var num_rays: int
var layer_mask
@export var raycast_enabled: bool
@export var no_physics_modifiers_if_on_ground: bool
@export var last_collision_distance: float
@export var approach_distance: float
@export var margin: float
@export var real_collision_distance: float
@export var base_horizontal_motion_of_object: float
@export var base_vertical_motion_of_object: float
@export var colliding: bool
@export var colliding_wall: bool
@export var colliding_hazard: bool
@export var colliding_special_button: bool
@export var number_ray_hits: int
static var option_a_check_mask: int
static var option_a_ignore_mask: int
static var option_b_mask: int
static var option_c_mask: int
static var option_d_mask: int
var hit: Array
var scaled_margin: float  # C# property

func on_raycast_hit_collider(c: CollisionShape2D) -> bool:  # C# OnRaycastHitCollider
	return false

func on_raycast_hit_solid_surface(c: CollisionShape2D) -> bool:  # C# OnRaycastHitSolidSurface
	return false

func raycast_update() -> void:  # C# RaycastUpdate
	pass
