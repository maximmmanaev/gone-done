# Ported from structur/PartyBox.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyBox
extends UIGraphic

enum BlockSelectionMode {
	Random,
	ForceStartMostlyPlatforms,
	ForcePlatforms,
}
var groups: Array
@export var item_scale: float
var pieces: Array
var cursors: Array
var remaining_picking_cursor: int
@export var box_size: Vector2
@export var placement_offset: Vector3
@export var challenge_range: float
@export var max_lose_streak: int
@export var placement_radius: float
@export var radius_range: float
@export var cursor_radius: float
@export var cursor_appear_delay: float
@export var cursor_enable_delay: float
var cursor_prefab: PartyPickCursor
@export var last_diff: float
@export var last_area: float
@export var box_animator: AnimationPlayer
var paused: bool
var scoreboard: bool
@export var extra_box_l: Texture2D
@export var extra_box_r: Texture2D
@export var regular_party_l: Texture2D
@export var regular_party_r: Texture2D
@export var chinese_traditional_l: Texture2D
@export var chinese_traditional_r: Texture2D
@export var chinese_simplified_l: Texture2D
@export var chinese_simplified_r: Texture2D
@export var box_top_l: Sprite2D
@export var box_top_r: Sprite2D
@export var box_flap_l: Node2D
@export var box_flap_r: Node2D
var box_flap_sprites: Array
var net_surrogate
@export var has_authority: bool
var cursors_found: bool
@export var ui_camera: Camera2D
var bomb_prefab: Array
var coin_prefab: Placeable
var twitch_selected_items: Array
const HIDE_DELAY: float = 0.5
var hide_counter: float
var block_selection_mode
@export var density: float
@export var difficulty: float
var base_block_weights: WeightedBlockList
var current_block_weights: WeightedBlockList
var bomb_prefab_weights: WeightedBlockList
var coin_prefab_weights: WeightedBlockList
var glue_prefab: Placeable
var filtered_variant_list: Dictionary
@export var block_weight_debug_holder: Node2D
@export var top_right_handle: Node2D
var debug_pickables: Array
@export var random_y: float
@export var debug_weight_display: bool
var debug_weight_display_initialized: bool
var partybox_debug: bool
var is_still_active: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func generate_additional_pieces(forced_bombs: int, forced_coins: int) -> Array:  # C# GenerateAdditionalPieces
	return []

func choose_pieces(amount: int, force_blocks: Array) -> void:  # C# ChoosePieces
	pass

func initialize_weighted_block_list() -> void:  # C# InitializeWeightedBlockList
	pass

func initialize_filtered_variant_list() -> void:  # C# InitializeFilteredVariantList
	pass

func initialize_filtered_bombs_and_coins() -> void:  # C# InitializeFilteredBombsAndCoins
	pass

func initialize_weight_block_debug_view() -> void:  # C# InitializeWeightBlockDebugView
	pass

func display_computed_weigths_debug() -> void:  # C# DisplayComputedWeigthsDebug
	pass

func compute_effective_block_weights() -> void:  # C# ComputeEffectiveBlockWeights
	pass

func select_random_piece() -> PickableBlock:  # C# SelectRandomPiece
	return null

func bound_setter(block: PickableBlock, center_pos: Vector3, collider: CollisionShape2D, outside_bounds: AABB) -> Vector3:  # C# BoundSetter
	return Vector3.ZERO

func set_player_count(players: int) -> void:  # C# SetPlayerCount
	pass

func add_player_2(player_number: int, animal) -> PartyPickCursor:  # C# AddPlayer
	return null

func clear_pieces() -> void:  # C# ClearPieces
	pass

func show_box(extra_box: bool) -> void:  # C# ShowBox
	pass

func hide_1(force_quick_hide: bool) -> void:  # C# Hide
	pass

func center_cursors() -> void:  # C# CenterCursors
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func finish_hide() -> void:  # C# FinishHide
	pass

func shake() -> void:  # C# shake
	pass

func open_flaps() -> void:  # C# openFlaps
	pass

func close_flaps() -> void:  # C# closeFlaps
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass

func to_place_mode_0() -> void:  # C# ToPlaceMode
	pass

func box_flap_order(top_box_flaps: bool) -> void:  # C# boxFlapOrder
	pass

func box_flap_front() -> void:  # C# boxFlapFront
	pass

func box_flap_back() -> void:  # C# boxFlapBack
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func on_piece_picked(pick_msg: MsgPiecePicked) -> void:  # C# OnPiecePicked
	pass

func on_box_open(box_open_msg: MsgPartyBoxOpen) -> void:  # C# OnBoxOpen
	pass

func _process(delta: float) -> void:  # C# Update
	pass
