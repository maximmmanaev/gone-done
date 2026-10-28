# Ported from structur/FireHydrant.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FireHydrant
extends ActiveBlock

@export var geyser: CollisionShape2D
@export var cap: Node2D
@export var cap_projectile: CollisionShape2D
@export var interval: float
@export var rise_time: float
@export var fall_time: float
@export var rise_height: float
@export var timer: float
@export var on: bool
@export var animating: bool
@export var hydrant_animator: AnimationPlayer
@export var height: float
var real: bool
var geyser_pos: Vector3
var cap_pos: Vector3

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
