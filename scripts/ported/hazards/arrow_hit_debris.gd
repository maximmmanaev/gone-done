# Ported from structur/ArrowHitDebris.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ArrowHitDebris
extends Node2D

var ease_settle: Curve
@export var destroy_after_seconds: float

func start_settle_hit_debirs(start_local: Vector3, end_local_diff: Vector3, start_rotation: Quaternion, endrotation_diff: Quaternion, time_of_settle: float) -> void:  # C# startSettleHitDebirs
	pass

func settle_hit_debris(start_local: Vector3, end_local_diff: Vector3, start_rotation: Quaternion, endrotation_diff: Quaternion, time_of_settle: float):  # C# settleHitDebris (coroutine)
	pass

func destroy_after_awhile():  # C# destroyAfterAwhile (coroutine)
	pass
