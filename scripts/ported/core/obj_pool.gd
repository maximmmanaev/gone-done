# Ported from structur/ObjPool.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ObjPool
extends Node2D

var pool_queue: Array
static var pool_holder: Node2D
var pooled_object_prefab: Node2D
var pool_size: int

func initilize(pooled_object_prefab: Node2D, pool_size: int) -> void:  # C# Initilize
	pass

func increase_pool_size(num_objects: int) -> void:  # C# IncreasePoolSize
	pass

func get_obj_from_pool() -> Node2D:  # C# GetObjFromPool
	return null

func add_obj_to_pool(obj: Node2D) -> void:  # C# AddObjToPool
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass
