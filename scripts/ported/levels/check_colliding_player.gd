# Ported from structur/CheckCollidingPlayer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CheckCollidingPlayer
extends Node2D

@export var colliding: bool
@export var hazard: bool
@export var hazard_type: String
@export var death_pit: bool
@export var hazard_placed_by_player: int
@export var hazard_point: Vector3
@export var check_tag: String
@export var ignore_tag: String
var check_tag_mask
var ignore_tag_mask
@export var colliding_last_frame: bool
@export var hazard_last_frame: bool
var associated_character: Character
var last_colliding_piece: Placeable
var last_colliding_physics_piece: Placeable
var last_colliding_object: Node2D
var tag_comparer
var main_colliders: Array
@export var claw: CollisionShape2D
var u_enabled: bool  # C# property

func enable_0() -> void:  # C# Enable
	pass

func enable_claw() -> void:  # C# EnableClaw
	pass

func disable_claw() -> void:  # C# DisableClaw
	pass

func disable_0() -> void:  # C# Disable
	pass

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass

func on_collision_stay_2d(c) -> void:  # C# OnCollisionStay2D
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func deal_with_collision(c: CollisionShape2D) -> void:  # C# DealWithCollision
	pass

func deal_with_collision_2(c) -> void:  # C# DealWithCollision
	pass

func is_death_pit(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsDeathPit
	return false

func has_no_physic_modifier(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# HasNoPhysicModifier
	return false

func deal_with_collision_3(go: Node2D) -> void:  # C# DealWithCollision
	pass

func pass_physics_modifier(go: Node2D, collision_tag: CollisionTag) -> void:  # C# PassPhysicsModifier
	pass
