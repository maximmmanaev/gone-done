# Ported from structur/MsgProjectileDestroyed.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgProjectileDestroyed
extends RefCounted

var launcher_id: int
var projectile_number: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
