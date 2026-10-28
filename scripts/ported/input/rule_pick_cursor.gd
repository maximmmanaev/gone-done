# Ported from structur/RulePickCursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RulePickCursor
extends PickCursor

func _ready() -> void:  # C# Start
	pass

func deal_with_pickable() -> void:  # C# dealWithPickable
	pass

func on_inventory() -> void:  # C# OnInventory
	pass

func on_back() -> void:  # C# OnBack
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
