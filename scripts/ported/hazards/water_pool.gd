# Ported from structur/WaterPool.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WaterPool
extends Node2D

const PLAYER_TAG: String = "Solid_Player"
static var player_layer: Array
static var hazard_layer: Array
var splash_prefab: WaterSplash
var pool_size: int
var splashing_objects: Array
var splash_pool: Dictionary
var colliders_in_trigger: Array
var box_collider: CollisionShape2D
var old_objects_in_trigger: Array

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func check_for_splash(c: CollisionShape2D) -> void:  # C# CheckForSplash
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func update_colliders_in_trigger() -> void:  # C# UpdateCollidersInTrigger
	pass

func remove_splash(splash: WaterSplash) -> void:  # C# removeSplash
	pass

func create_splash_1(obj: Node2D) -> void:  # C# createSplash
	pass

func create_splash_2(obj: Node2D, position: Vector3) -> void:  # C# createSplash
	pass

func get_top_parent(obj: Node2D) -> Node2D:  # C# getTopParent
	return null
