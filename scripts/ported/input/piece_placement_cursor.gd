# Ported from structur/PiecePlacementCursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PiecePlacementCursor
extends CursorUnity

var inventory_book_menu
var cursor_control_hints: CursorControlHints
var net_surrogate_prefab
@export var selection_collider: CollisionShape2D
var hold_b_indicator_instance
var alt_hold_b_indicator_instance
@export var multiple_placement: bool
@export var switch_time: float
@export var keep_piece: bool
@export var waiting_for_place_message_response: bool
var piece_sprite_renderers: Array
var switch_timer: float
var back_just_pressed: bool
var trying_to_cancel: bool
var selection_collider_last_state: bool
var held_position_offset: Vector3
var placement_physics_lock: bool
var controls_canvas: CanvasLayer
var placements_left_canvas: CanvasLayer
@export var placements_left_text: Label
var accept_down_hovered_piece: Placeable
var accept_down_position_offset: Vector3
var sprint_down_hovered_piece: Placeable
var sprint_down_position_offset: Vector3
var current_camera_flip_mode
static var raycast_result_cache: Array
var selection_layer_mask
@export var selection_box_size: Vector2
@export var selection_offset: Vector3
@export var num_hits: int
var potential_selections: Array
var buttons_not_to_hide: Array
const ROTATE_TEXT: String = "Inventory/Rotate"
const FLIP_TEXT: String = "Inventory/Flip"
static var k_cmd_cmd_rotate_piece: int
static var k_rpc_rpc_rotate_piece: int
static var k_cmd_cmd_switch_free_mode: int
static var k_rpc_rpc_switch_free_mode: int
static var k_cmd_cmd_spawn_net_surrogate: int
static var k_cmd_cmd_clear_piece: int
static var k_rpc_rpc_clear_piece: int
static var k_rpc_rpc_set_placements_left_text: int
static var k_cmd_cmd_set_held_position_offset: int
var piece: Placeable  # C# property
var placed: bool  # C# property
var holding_piece_offset: float  # C# property
var networkheld_position_offset: Vector3  # C# property

func set_sprites(sprite_lib) -> void:  # C# SetSprites
	pass

func _ready() -> void:  # C# Start
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func set_piece(piece: Placeable, destroy_previous: bool, pickup: bool) -> void:  # C# SetPiece
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func switch_to_play() -> void:  # C# switchToPlay
	pass

func clamp_to_boundary_0() -> void:  # C# ClampToBoundary
	pass

func clamp_to_boundary_1(boundary: AABB) -> void:  # C# ClampToBoundary
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_accept_0() -> void:  # C# OnAccept
	pass

func on_accept_down() -> void:  # C# OnAcceptDown
	pass

func on_accept_up() -> void:  # C# OnAcceptUp
	pass

func on_sprint_down() -> void:  # C# OnSprintDown
	pass

func on_sprint_up() -> void:  # C# OnSprintUp
	pass

func on_back() -> void:  # C# OnBack
	pass

func wait_for_piece_reset():  # C# waitForPieceReset (coroutine)
	pass

func on_rotate_left() -> void:  # C# OnRotateLeft
	pass

func on_rotate_right() -> void:  # C# OnRotateRight
	pass

func perform_left_rotation(sprint_pressed: bool) -> void:  # C# PerformLeftRotation
	pass

func perform_right_rotation(sprint_pressed: bool) -> void:  # C# PerformRightRotation
	pass

func on_inventory() -> void:  # C# OnInventory
	pass

func disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func ui_update() -> void:  # C# UIUpdate
	pass

func hide_0() -> void:  # C# Hide
	pass

func place_piece_deferred(place_msg: MsgPiecePlaced, piece: Placeable, piece_was_picked_up: bool) -> void:  # C# PlacePieceDeferred
	pass

func wait_for_placement(place_msg: MsgPiecePlaced, piece: Placeable, piece_was_picked_up: bool):  # C# WaitForPlacement (coroutine)
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func cmd_rotate_piece(clockwise: bool, sprint_pressed: bool) -> void:  # C# CmdRotatePiece
	pass

func rpc_rotate_piece(clockwise: bool, sprint_pressed: bool) -> void:  # C# RpcRotatePiece
	pass

func cmd_switch_free_mode() -> void:  # C# CmdSwitchFreeMode
	pass

func rpc_switch_free_mode() -> void:  # C# RpcSwitchFreeMode
	pass

func cmd_spawn_net_surrogate(spawn_for_block_id: int) -> void:  # C# CmdSpawnNetSurrogate
	pass

func cmd_clear_piece() -> void:  # C# CmdClearPiece
	pass

func rpc_clear_piece() -> void:  # C# RpcClearPiece
	pass

func pickup_piece(p: Placeable) -> void:  # C# PickupPiece
	pass

func clear_current_piece() -> void:  # C# ClearCurrentPiece
	pass

func rpc_set_placements_left_text(n: int) -> void:  # C# RpcSetPlacementsLeftText
	pass

func cmd_set_held_position_offset(v: Vector3) -> void:  # C# CmdSetHeldPositionOffset
	pass

func init_controller_buttons(used_controller: Controller) -> void:  # C# InitControllerButtons
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_rotate_piece(obj, reader) -> void:  # C# InvokeCmdCmdRotatePiece
	pass

static func invoke_cmd_cmd_switch_free_mode(obj, reader) -> void:  # C# InvokeCmdCmdSwitchFreeMode
	pass

static func invoke_cmd_cmd_spawn_net_surrogate(obj, reader) -> void:  # C# InvokeCmdCmdSpawnNetSurrogate
	pass

static func invoke_cmd_cmd_clear_piece(obj, reader) -> void:  # C# InvokeCmdCmdClearPiece
	pass

static func invoke_cmd_cmd_set_held_position_offset(obj, reader) -> void:  # C# InvokeCmdCmdSetHeldPositionOffset
	pass

func call_cmd_rotate_piece(clockwise: bool, sprint_pressed: bool) -> void:  # C# CallCmdRotatePiece
	pass

func call_cmd_switch_free_mode() -> void:  # C# CallCmdSwitchFreeMode
	pass

func call_cmd_spawn_net_surrogate(spawn_for_block_id: int) -> void:  # C# CallCmdSpawnNetSurrogate
	pass

func call_cmd_clear_piece() -> void:  # C# CallCmdClearPiece
	pass

func call_cmd_set_held_position_offset(v: Vector3) -> void:  # C# CallCmdSetHeldPositionOffset
	pass

static func invoke_rpc_rpc_rotate_piece(obj, reader) -> void:  # C# InvokeRpcRpcRotatePiece
	pass

static func invoke_rpc_rpc_switch_free_mode(obj, reader) -> void:  # C# InvokeRpcRpcSwitchFreeMode
	pass

static func invoke_rpc_rpc_clear_piece(obj, reader) -> void:  # C# InvokeRpcRpcClearPiece
	pass

static func invoke_rpc_rpc_set_placements_left_text(obj, reader) -> void:  # C# InvokeRpcRpcSetPlacementsLeftText
	pass

func call_rpc_rotate_piece(clockwise: bool, sprint_pressed: bool) -> void:  # C# CallRpcRotatePiece
	pass

func call_rpc_switch_free_mode() -> void:  # C# CallRpcSwitchFreeMode
	pass

func call_rpc_clear_piece() -> void:  # C# CallRpcClearPiece
	pass

func call_rpc_set_placements_left_text(n: int) -> void:  # C# CallRpcSetPlacementsLeftText
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
