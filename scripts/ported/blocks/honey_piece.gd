# Ported from structur/HoneyPiece.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name HoneyPiece
extends MultipiecePart

@export var stickiness: float
@export var jump_stickiness: float
var dummy_source: Node2D
var honey_sticker_prefab: HoneySticker
@export var sticky_start: Node2D
@export var sticky_end: Node2D
var honey_attachment_dont_ignore_picked_up: CheckColliding
@export var not_sticky: bool
var last_reverse_attachment: Placeable
var can_stick_it_to_players: bool  # C# property
var has_reverse_attachment: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return []

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func trigger_stickness(sticky_target: Node2D) -> void:  # C# triggerStickness
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func enable_0() -> void:  # C# Enable
	pass

func can_place() -> bool:  # C# CanPlace
	return false

func required_collider_conditions_satisfied() -> bool:  # C# RequiredColliderConditionsSatisfied
	return false

func pick_up() -> void:  # C# PickUp
	pass
