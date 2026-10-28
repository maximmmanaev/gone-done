# Ported from structur/MsgNetworkSurrogateSpawned.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgNetworkSurrogateSpawned
extends RefCounted

var net_surrogate_id
var spawned_for_piece_id: int

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
