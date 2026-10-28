# Ported from structur/SmokePool.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SmokePool
extends Node2D

enum SmokeType {
	POOF,
	JUMP,
	WALL_L,
	WALL_R,
	LAND,
	UIPOOF,
	MULTIJUMP,
	ANIMALCANNON_SMOKE,
	ANIMLACANNON_BLUR,
}
var jump_smoke_prefab: SmokeEffect
@export var jump_pool_size: int
var wall_left_prefab: SmokeEffect
@export var wall_left_size: int
var wall_right_prefab: SmokeEffect
@export var wall_right_size: int
var land_dust_prefab: SmokeEffect
@export var land_pool_size: int
var poof_prefab: SmokeEffect
@export var smoke_pool_size: int
var ui_smoke_prefab: SmokeEffect
@export var ui_smoke_pool_size: int
var multi_jump_smoke_prefab: SmokeEffect
@export var multi_jump_pool_size: int
var animal_cannon_character_smoke_prefab: SmokeEffect
@export var animal_cannon_character_smoke_pool_size: int
var animal_cannon_character_blur_prefab: SmokeEffect
@export var animal_cannon_character_blur_pool_size: int
var jump_pool: Array
var wall_left_pool: Array
var wall_right_pool: Array
var land_pool: Array
var poof_pool: Array
var ui_smoke_pool: Array
var multi_jump_smoke_pool: Array
var animal_cannon_character_smoke_pool: Array
var animal_cannon_character_blur_pool: Array
var initialized: bool
static var instance: SmokePool

func _enter_tree() -> void:  # C# Awake
	pass

func initialize_0() -> void:  # C# Initialize
	pass

func spawn_smoke_2(type, position: Vector3) -> SmokeEffect:  # C# SpawnSmoke
	return null

func spawn_smoke_3(type, position: Vector3, scale: float) -> SmokeEffect:  # C# SpawnSmoke
	return null

func spawn_smoke_4(type, position: Vector3, scale: float, tint: Color) -> SmokeEffect:  # C# SpawnSmoke
	return null

func spawn_smoke_5(type, position: Vector3, scale: float, tint: Color, layer_name: String) -> SmokeEffect:  # C# SpawnSmoke
	return null

func spawn_smoke_5_2(type, position: Vector3, scale: float, tint: Color, layer: int) -> SmokeEffect:  # C# SpawnSmoke
	return null

func spawn_smoke_transform(type, transform: Node2D, tint) -> SmokeEffect:  # C# SpawnSmokeTransform
	return null
