# Ported from structur/PartyCursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyCursor
extends PiecePlacementCursor

@export var picked: bool
var lock_set: bool
static var placement_lock: bool

func set_sprites(sprite_lib) -> void:  # C# SetSprites
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func set_piece(piece: Placeable, destroy_previous: bool, pickup: bool) -> void:  # C# SetPiece
	pass

func on_accept_0() -> void:  # C# OnAccept
	pass

func on_back() -> void:  # C# OnBack
	pass

func enable_0() -> void:  # C# Enable
	pass

func try_pick_piece():  # C# tryPickPiece (coroutine)
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
