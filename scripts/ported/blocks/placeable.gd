# Каркас из structur/Placeable.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name Placeable
extends Node2D

enum OrientMode {
	ROTATE,
	FLIPX,
	FLIPY,
	NONE,
	FLIPXANDY,
}

enum PieceCategory {
	PLATFORM,
	TRAP,
	MOVINGPLATFORM,
	ATTACHMENT,
	BOMB,
	SPECIAL,
	ITEM,
}

enum RotationDirections {
	None,
	Clockwise,
	CounterClockwise,
}

enum Tag {
	None = 0,
	StaticBlock = 1,
	DynamicBlock = 2,
	Hazard = 4,
	ProjectileLauncher = 8,
	Bomb = 0x10,
	Coin = 0x20,
	Glue = 0x40,
	Attachment = 0x80,
	SetPiece = 0x100,
	MovingPlatform = 0x200,
}

enum Rarity {
	NeverPick = 0,
	Rare = 200,
	Normal = 1000,
	Common = 2000,
}
static var id_count: int
@export var id: int
@export var u_name: String
@export var kill_type: String
@export var sfx_event_name: String
@export var sfx_destruction: String
@export var twitch_short_name: String
var category
var placeable_tag
var pickable_block: PickableBlock
var inventory_instance: Placeable
@export var placement_offset: Vector2
@export var ignore_offset_in_rotation: bool
@export var default_sorting_layer: String
@export var debug_show_group_links: bool
@export var block_probability_ui_order: int
var base_rarity
@export var use_glued_variant_modifier: float
@export var area: float
@export var challenge: float
@export var u_mass: float
@export var mass_influence_ratio: float
@export var maximum_mass_speed_ratio: float
@export var radius_calculated_mass: bool
@export var center_of_mass: Node2D
@export var permanent: bool
@export var in_destructible: bool
@export var dont_change_art_layers: bool
@export var dont_follow_parent_layer: bool
@export var always_moving_sprite_layer: bool
@export var use_default_sorting_layer_even_when_moving: bool
@export var attached_piece_moving_layer: bool
@export var limit_to_art_sprites: bool
var parent_piece: Placeable
@export var attaches_to_parent: bool
var filter_override: Array
@export var ignore_placement_rules: bool
@export var ignore_bounds: bool
var create_explosion_animation: Array
var placement_colliders_new: Array
var active_colliders_new: Array
var all_collider_controls: Array
var placement_guides: Array
var art_sprites: Array
var sprite_sort_order
var group: AttachmentGroup
@export var original_position: Vector2
@export var original_rotation: Quaternion
var original_scale: Vector3
@export var explosion_smoke_debris: Node2D
@export var scale_smoke_debris: bool
var smoke_poofused: bool
var orientation
var orientation_alt
var marked_for_destruction: bool
@export var protected: bool
var hovered_cursors: Array
var picked_up: bool
@export var relative_attach_position: Vector3
@export var keep_relative_attach_position: bool
var child_pieces: Array
var placed: bool
var u_disabled: bool
var pms: Array
@export var placement_lock: bool
var bomb_tints: int
var bomb_tint_color: Color
@export var placed_by_player_number: int
@export var none_default_colors: bool
@export var custom_subtract_highlight: Color
var initial_colors: Array
@export var is_networked: bool
var net_surrogate
@export var is_saveable: bool
@export var is_sub_element: bool
@export var original_sub_element_name: String
@export var placement_cost: int
@export var duplicable: bool
@export var interactable_in_free_play_only: bool
@export var is_set_piece: bool
@export var attachable_with_glue: bool
@export var can_set_custom_color: bool
@export var custom_color: Color
@export var damageable: bool
@export var damage_level: int
@export var always_save_damage: bool
@export var destroyed_damage_level: int
@export var initial_damage: int
var can_place_check_this_fixed_update: bool
var can_place_cache: bool
@export var constrain_x: bool
@export var constrain_y: bool
var attached_by: Array
@export var dont_block_glue_sticky: bool
static var all_placeables: Array
static var can_place_attachment_mask
static var raycast_result_cache: Array
static var attachment_collider_mask
var reverse_attachments: Array  # C# property
var placing: bool  # C# property
var in_inventory: bool  # C# property
var u_enabled: bool = true  # C# property
var has_reverse_attachments: bool  # C# property
var rotation_direction  # C# property
var interactable_in_current_mode: bool  # C# property
var is_mobile_block: bool  # C# property
var useful_name: String  # C# property

func _enter_tree() -> void:  # C# Awake
	if id == 0:
		id_count += 1
		id = id_count

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	for c in zone_characters:
		if is_instance_valid(c):
			on_character_exited(c)
	zone_characters.clear()

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass


func switch_collider_to(mode: int) -> void:  # C# SwitchColliderTo
	pass

func add_bomb_tint(c: Color) -> void:  # C# AddBombTint
	pass

func remove_bomb_tint() -> void:  # C# RemoveBombTint
	pass

func tint() -> void:  # C# Tint
	pass

func disable_0() -> void:  # C# Disable
	u_disabled = true
	u_enabled = false
	for c in zone_characters:
		if is_instance_valid(c):
			on_character_exited(c)

func enable_0() -> void:  # C# Enable
	u_disabled = false
	u_enabled = true
	for c in zone_characters:
		if is_instance_valid(c):
			on_character_entered(c)

func sprite_assignment_rule(sr: Sprite2D) -> void:  # C# SpriteAssignmentRule
	pass

func enable_placement(show_guides: bool) -> void:  # C# EnablePlacement
	placing = true

func enable_placed() -> void:  # C# EnablePlaced
	placing = false
	u_enabled = true
	u_disabled = false

func update_sort_order() -> void:  # C# UpdateSortOrder
	pass

func pick_up() -> void:  # C# PickUp
	set_picked_up(true)

func place_1(player_number: int) -> void:  # C# Place
	place_3(player_number, false, false)

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	placed_by_player_number = player_number
	placed = true
	picked_up = false
	original_position = position
	enable_placed()

func reset_transform(player_number: int) -> void:  # C# ResetTransform
	position = original_position

func can_place() -> bool:  # C# CanPlace
	return not placement_lock and not marked_for_destruction and not picked_up

func can_place_check() -> bool:  # C# CanPlaceCheck
	can_place_cache = can_place()
	return can_place_cache

func get_top_piece() -> Placeable:  # C# GetTopPiece
	var p: Placeable = self
	while p.parent_piece != null:
		p = p.parent_piece
	return p

func flip(sprint_down: bool) -> void:  # C# Flip
	scale.x = -scale.x

func get_total_mass() -> float:  # C# GetTotalMass
	var m := u_mass
	for p in child_pieces:
		if is_instance_valid(p):
			m += p.get_total_mass()
	return m

func get_physics_modifiers() -> Array:  # C# GetPhysicsModifiers
	return []

func get_physics_modifier() -> Array:  # C# GetPhysicsModifier
	return get_physics_modifiers()

func get_pieces_at_attach_points() -> Array:  # C# GetPiecesAtAttachPoints
	return []

func attach_piece(p: Placeable) -> void:  # C# AttachPiece
	if p == null or child_pieces.has(p):
		return
	child_pieces.append(p)
	p.parent_piece = self

func detach_piece(p: Placeable, remove_from_group: bool) -> void:  # C# DetachPiece
	child_pieces.erase(p)
	if p != null and p.parent_piece == self:
		p.parent_piece = null

func detach_all_children(keep_attachments: bool) -> void:  # C# DetachAllChildren
	for p in child_pieces:
		if is_instance_valid(p) and p.parent_piece == self:
			p.parent_piece = null
	child_pieces.clear()

func ignore_collisions_upward(p: Placeable, ignore: bool) -> void:  # C# IgnoreCollisionsUpward
	pass

func destroy_self_in(destroy_children: bool, use_smoke: bool, time: float) -> void:  # C# DestroySelfIn
	await get_tree().create_timer(time).timeout
	if is_instance_valid(self):
		destroy_self_3(destroy_children, use_smoke, false)

func coroutine_destroy_self(destroy_children: bool, use_smoke: bool, time: float):  # C# CoroutineDestroySelf (coroutine)
	pass

func create_smoke_poof() -> void:  # C# CreateSmokePoof
	pass

func destroy_self_3(destroy_children: bool, use_smoke: bool, send_network_signal: bool) -> void:  # C# DestroySelf
	if marked_for_destruction:
		return
	marked_for_destruction = true
	if destroy_children:
		for p in child_pieces.duplicate():
			if is_instance_valid(p):
				p.destroy_self_3(true, use_smoke, send_network_signal)
	disable_0()
	if parent_piece != null:
		parent_piece.detach_piece(self, true)
	queue_free()

func set_picked_up(value: bool) -> void:  # C# setPickedUp
	picked_up = value
	placed = not value
	if value:
		disable_0()
	else:
		enable_0()

func to_play_mode() -> void:  # C# ToPlayMode
	placing = false

func enable_next_frame():  # C# EnableNextFrame (coroutine)
	pass

func to_place_mode_1(enable_selection: bool) -> void:  # C# ToPlaceMode
	placing = true

func to_sudden_death() -> void:  # C# ToSuddenDeath
	pass

func end_play() -> void:  # C# EndPlay
	placing = false

func handle_event(e) -> void:  # C# handleEvent
	pass

func generate_id_on_pick(sequence_id: int, player_network_number: int) -> void:  # C# GenerateIDOnPick
	pass

func update_child_i_ds() -> void:  # C# UpdateChildIDs
	pass

func get_original_sequence_id() -> int:  # C# GetOriginalSequenceID
	return id

static func set_initial_sequence_id(id: int) -> void:  # C# SetInitialSequenceID
	pass

func apply_transform_from_message(piece_msg: MsgBookPiecePicked) -> void:  # C# ApplyTransformFromMessage
	pass

func u_set_color(new_color: Color) -> void:  # C# SetColor
	custom_color = new_color
	modulate = new_color

func get_linked_set_pieces() -> Array:  # C# GetLinkedSetPieces
	return []

func required_collider_conditions_satisfied() -> bool:  # C# RequiredColliderConditionsSatisfied
	return false

func calculate_mass_ratio() -> float:  # C# calculateMassRatio
	return mass_influence_ratio

func get_children_and_parts() -> Array:  # C# GetChildrenAndParts
	return child_pieces.duplicate()

func detach_children_for_pickup(detach_from_parent: bool) -> void:  # C# DetachChildrenForPickup
	pass

func set_initial_damage_level(damage: int, allow_damage_reset: bool) -> void:  # C# SetInitialDamageLevel
	damage_level = damage
	if allow_damage_reset:
		initial_damage = damage

func add_bomb_damage(damage_amount: int) -> void:  # C# AddBombDamage
	if not damageable or protected:
		return
	damage_level += damage_amount
	if damage_level >= destroyed_damage_level and destroyed_damage_level > 0:
		destroy_self_3(true, true, false)

func get_transformed_placement_offset() -> Vector3:  # C# GetTransformedPlacementOffset
	return Vector3.ZERO

# ---- зона: Area2D, которая следит за персонажами рядом с блоком ----
const PLAYER_LAYER := 2
var zone: Area2D
var zone_characters: Array = []
var clock := 0.0


func _physics_process(delta: float) -> void:
	clock += delta


## Блок «живой», если включён, не поднят и не в режиме расстановки.
func is_live() -> bool:
	return u_enabled and not u_disabled and not picked_up and not placing


func setup_zone(size: Vector2, offset := Vector2.ZERO) -> Area2D:
	if zone:
		zone.queue_free()
	zone = Area2D.new()
	zone.collision_layer = 0
	zone.collision_mask = PLAYER_LAYER
	zone.monitorable = false
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	shape.position = offset
	zone.add_child(shape)
	zone.body_entered.connect(_zone_body_entered)
	zone.body_exited.connect(_zone_body_exited)
	add_child(zone)
	return zone


func _zone_body_entered(body: Node) -> void:
	if body is Character and not zone_characters.has(body):
		zone_characters.append(body)
		if is_live():
			on_character_entered(body)


func _zone_body_exited(body: Node) -> void:
	if zone_characters.has(body):
		zone_characters.erase(body)
		on_character_exited(body)


## По умолчанию — применяет к персонажу физические модификаторы блока (get_physics_modifiers), пока он в зоне.
func on_character_entered(c: Character) -> void:
	if c.is_ghost:
		return
	var merged := {}
	for pm: Dictionary in get_physics_modifiers():
		for k in pm:
			merged[k] = merged.get(k, 1.0) * pm[k]
	if not merged.is_empty():
		c.apply_physics_modifier(self, merged)


func on_character_exited(c: Character) -> void:
	c.remove_physics_modifier(self)


## Вернуть блок в исходное состояние перед новым забегом (переопределяют движущиеся блоки).
func reset_play_state() -> void:
	pass
