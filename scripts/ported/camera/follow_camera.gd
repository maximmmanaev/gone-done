# Ported from structur/FollowCamera.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FollowCamera
extends Node2D

@export var horizontal_buffer: float
@export var vertical_buffer: float
@export var follow_speed: float
@export var target: Node2D
var boundary: AABB
var aspect_ratio: float
@export var u_width: float
@export var height: float
var target_speed: float
var follow_target: bool

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func set_bounds(bounds: AABB) -> void:  # C# SetBounds
	pass

func set_target(target: Node2D, speed: float) -> void:  # C# SetTarget
	pass

func allow_follow(follow: bool) -> void:  # C# AllowFollow
	pass
