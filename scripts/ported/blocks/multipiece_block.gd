# Ported from structur/MultipieceBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MultipieceBlock
extends ActiveBlock

@export var use_sprite_parts: bool
@export var left: Texture2D
@export var center: Texture2D
@export var right: Texture2D
@export var single: Texture2D
var parts: Array
@export var separable: bool

func _enter_tree() -> void:  # C# Awake
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func activate_0() -> void:  # C# Activate
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func enable_placement(show_guides: bool) -> void:  # C# EnablePlacement
	pass

func enable_placed() -> void:  # C# EnablePlaced
	pass

func can_place() -> bool:  # C# CanPlace
	return false

func can_place_with_parts() -> bool:  # C# CanPlaceWithParts
	return false

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func set_picked_up(value: bool) -> void:  # C# setPickedUp
	pass

func remove_part(part: MultipiecePart) -> void:  # C# RemovePart
	pass

func destroy_self_3(destroy_children: bool, use_smoke: bool, send_network_signal: bool) -> void:  # C# DestroySelf
	pass

func get_total_mass() -> float:  # C# GetTotalMass
	return 0.0

func detach_all_children(keep_attachments: bool) -> void:  # C# DetachAllChildren
	pass

func pick_up() -> void:  # C# PickUp
	pass

func u_set_color(new_color: Color) -> void:  # C# SetColor
	pass

func get_children_and_parts() -> Array:  # C# GetChildrenAndParts
	return []

func tint() -> void:  # C# Tint
	pass
