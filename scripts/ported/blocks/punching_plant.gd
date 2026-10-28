# Ported from structur/PunchingPlant.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingPlant
extends ActiveBlock

@export var fear_time: float
@export var punch_strength: float
var animator: AnimationPlayer
var afraid: bool
var punching: bool
var mirrored: bool
var punch_targets: Array
var ray_hits: Array
@export var ray_cast_origin: Node2D
var layer_mask
static var solid_player_mask

func _ready() -> void:  # C# Start
	pass

func is_solid_player(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsSolidPlayer
	return false

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func is_solid(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsSolid
	return false

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func be_afraid():  # C# beAfraid (coroutine)
	pass

func punch() -> void:  # C# punch
	pass

func reset() -> void:  # C# reset
	pass
