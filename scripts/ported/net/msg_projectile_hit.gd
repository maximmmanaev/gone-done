# Ported from structur/MsgProjectileHit.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgProjectileHit
extends RefCounted

var projectile_id
var collided_with
var hit_position: Vector3

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
