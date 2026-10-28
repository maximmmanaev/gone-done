# Ported from structur/Cursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CursorUnity
extends Node2D

@export var cursor_speed: float
@export var cursor_speed_multiplier: float
@export var accurate_slow_cursor: float
@export var network_number: int
@export var local_number: int
var local_player: PlayerUnity
var acceleration_curve: Curve
@export var acceleration_time: float
@export var bounding_box: CollisionShape2D
@export var piece_offset: Vector2
var associated_lobby_player
var associated_game_player: GamePlayer
@export var use_camera: Camera2D
var multi_controller_buttons: Array
@export var extra_zoom_speed: float
@export var extra_zoom: float
@export var extra_zoom_current: float
var hovered_piece: Placeable
var hovered_pick
var last_hovered_pick
@export var find_player_on_spawn: bool
@export var find_controller_on_spawn: bool
var name_tag: NameTag
@export var waiting_for_inventory: bool
var grid_position: Vector3
var cursor_sprite_renderer: Sprite2D
var u_disabled: bool
var paused: bool
var scoreboard: bool
var frozen: bool
var first_frame: bool
var boundary: AABB
var bounding_collider: CollisionShape2D
var cursor_accel_mult: float
var accelerating: bool
var cursor_color: Color
var cursor_animal
var bad: Texture2D
var ok: Texture2D
var notebook: Texture2D
var current_game_phase
var cursor_art_matcher: CursorArtMatcher
var waiting_for_fixed_update: bool
var fixed_update_happened: bool
var wait_for_enable_to_be_done: bool
var still_showing_on_client: bool
var afk_timer: float
var accept: bool
var start: bool
var back: bool
var sprint: bool
var button_sprint: bool
var trigger_sprint: bool
var inventory: bool
var rotate_left: bool
var rotate_right: bool
var accept_down: bool
var start_down: bool
var back_down: bool
var sprint_down: bool
var inventory_down: bool
var rotate_left_down: bool
var rotate_right_down: bool
var esc_down: bool
var accept_up: bool
var start_up: bool
var back_up: bool
var sprint_up: bool
var inventory_up: bool
var rotate_left_up: bool
var rotate_right_up: bool
var up: float
var down: float
var left: float
var right: float
var zoom_trigger: float
var zoom_toggle: bool
var following_mouse: bool
@export var use_screen_position: bool
var screen_position_controller: Controller
var mouse_reference_point: Vector3
var camera_change_timeout: float
var request_rotate_left: bool
var request_rotate_right: bool
@export var last_rotate_was_mouse_wheel: bool
const FRAMES_BETWEEN_ROTATIONS: int = 3
var last_rotation: int
@export var ignore_next_back_down: bool
static var k_cmd_cmd_set_sprites: int
static var k_rpc_rpc_set_sprites: int
static var k_cmd_cmd_set_local_player_id: int
static var k_rpc_rpc_find_local_player: int
static var k_cmd_cmd_get_local_controller: int
static var k_rpc_rpc_get_local_controller: int
static var k_cmd_cmd_set_waiting_for_inventory: int
static var k_cmd_cmd_enable: int
static var k_rpc_rpc_enable: int
static var k_cmd_cmd_disable: int
static var k_rpc_rpc_disable: int
static var k_cmd_cmd_freeze: int
static var k_rpc_rpc_freeze: int
static var k_cmd_cmd_unfreeze: int
static var k_rpc_rpc_unfreeze: int
static var k_cmd_cmd_pause: int
static var k_rpc_rpc_pause: int
static var k_cmd_cmd_unpause: int
static var k_rpc_rpc_unpause: int
static var k_cmd_cmd_hide: int
static var k_rpc_rpc_hide: int
var u_enabled: bool  # C# property
var held: bool  # C# property
var sprinting: bool  # C# property
var is_hovering: bool  # C# property
var time_spent_afk: float  # C# property
var is_controller_afk: bool  # C# property
var scrolling_mouse_wheel: bool  # C# property
var networknetwork_number: int  # C# property
var networklocal_number: int  # C# property
var network_find_player_on_spawn: bool  # C# property
var network_find_controller_on_spawn: bool  # C# property
var network_waiting_for_inventory: bool  # C# property
var networkdisabled: bool  # C# property
var networkpaused: bool  # C# property
var networkscoreboard: bool  # C# property
var networkfrozen: bool  # C# property
var networkcursor_color: Color  # C# property
var networkcursor_animal  # C# property

func hover_state() -> bool:  # C# hoverState
	return false

func hover_state_pick() -> bool:  # C# hoverStatePick
	return false

func on_touch_controls_enabled_changed(state: bool) -> void:  # C# OnTouchControlsEnabledChanged
	pass

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func on_accept_0() -> void:  # C# OnAccept
	pass

func on_start() -> void:  # C# OnStart
	pass

func on_back() -> void:  # C# OnBack
	pass

func on_rotate_left() -> void:  # C# OnRotateLeft
	pass

func on_rotate_right() -> void:  # C# OnRotateRight
	pass

func on_inventory() -> void:  # C# OnInventory
	pass

func set_bounds(bounding_collider: CollisionShape2D) -> void:  # C# SetBounds
	pass

func set_cursor_collider_bounds(bounding_collider: CollisionShape2D) -> void:  # C# SetCursorColliderBounds
	pass

func set_bounds_2(boundary: AABB) -> void:  # C# SetBounds
	pass

func set_sprites(animal) -> void:  # C# SetSprites
	pass

func cmd_set_sprites(animal) -> void:  # C# CmdSetSprites
	pass

func rpc_set_sprites(animal) -> void:  # C# RpcSetSprites
	pass

func set_sprites_2(sprite_lib) -> void:  # C# SetSprites
	pass

func update_layer_order(animal) -> void:  # C# UpdateLayerOrder
	pass

func reset_input() -> void:  # C# ResetInput
	pass

func hide_0() -> void:  # C# Hide
	pass

func disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func freeze_0() -> void:  # C# Freeze
	pass

func unfreeze() -> void:  # C# Unfreeze
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func u_set_color(c: Color) -> void:  # C# SetColor
	pass

func clamp_to_boundary_0() -> void:  # C# ClampToBoundary
	pass

func clamp_to_boundary_1(boundary: AABB) -> void:  # C# ClampToBoundary
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func check_camera_toggle() -> void:  # C# checkCameraToggle
	pass

func has_no_physic_modifier(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# HasNoPhysicModifier
	return false

func potential_hoever_piece(c: CollisionShape2D) -> Placeable:  # C# potentialHoeverPiece
	return null

func check_hovered_piece_add(p: Placeable) -> void:  # C# checkHoveredPieceAdd
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func cmd_set_local_player_id(local_number: int) -> void:  # C# CmdSetLocalPlayerID
	pass

func rpc_find_local_player(local_number: int) -> void:  # C# RpcFindLocalPlayer
	pass

func cmd_get_local_controller(local_number: int) -> void:  # C# CmdGetLocalController
	pass

func rpc_get_local_controller(local_number: int) -> void:  # C# RpcGetLocalController
	pass

func cmd_set_waiting_for_inventory(waiting: bool) -> void:  # C# CmdSetWaitingForInventory
	pass

func cmd_enable_0() -> void:  # C# CmdEnable
	pass

func rpc_enable_0() -> void:  # C# RpcEnable
	pass

func cmd_disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# CmdDisable
	pass

func rpc_disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# RpcDisable
	pass

func cmd_freeze() -> void:  # C# CmdFreeze
	pass

func rpc_freeze() -> void:  # C# RpcFreeze
	pass

func cmd_unfreeze() -> void:  # C# CmdUnfreeze
	pass

func rpc_unfreeze() -> void:  # C# RpcUnfreeze
	pass

func cmd_pause() -> void:  # C# CmdPause
	pass

func rpc_pause() -> void:  # C# RpcPause
	pass

func cmd_unpause() -> void:  # C# CmdUnpause
	pass

func rpc_unpause() -> void:  # C# RpcUnpause
	pass

func cmd_hide() -> void:  # C# CmdHide
	pass

func rpc_hide() -> void:  # C# RpcHide
	pass

func init_controller_buttons(used_controller: Controller) -> void:  # C# InitControllerButtons
	pass

func set_local_controller(used_controller: Controller) -> void:  # C# SetLocalController
	pass

func start_cursor_acceleration():  # C# startCursorAcceleration (coroutine)
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_set_sprites(obj, reader) -> void:  # C# InvokeCmdCmdSetSprites
	pass

static func invoke_cmd_cmd_set_local_player_id(obj, reader) -> void:  # C# InvokeCmdCmdSetLocalPlayerID
	pass

static func invoke_cmd_cmd_get_local_controller(obj, reader) -> void:  # C# InvokeCmdCmdGetLocalController
	pass

static func invoke_cmd_cmd_set_waiting_for_inventory(obj, reader) -> void:  # C# InvokeCmdCmdSetWaitingForInventory
	pass

static func invoke_cmd_cmd_enable(obj, reader) -> void:  # C# InvokeCmdCmdEnable
	pass

static func invoke_cmd_cmd_disable(obj, reader) -> void:  # C# InvokeCmdCmdDisable
	pass

static func invoke_cmd_cmd_freeze(obj, reader) -> void:  # C# InvokeCmdCmdFreeze
	pass

static func invoke_cmd_cmd_unfreeze(obj, reader) -> void:  # C# InvokeCmdCmdUnfreeze
	pass

static func invoke_cmd_cmd_pause(obj, reader) -> void:  # C# InvokeCmdCmdPause
	pass

static func invoke_cmd_cmd_unpause(obj, reader) -> void:  # C# InvokeCmdCmdUnpause
	pass

static func invoke_cmd_cmd_hide(obj, reader) -> void:  # C# InvokeCmdCmdHide
	pass

func call_cmd_set_sprites(animal) -> void:  # C# CallCmdSetSprites
	pass

func call_cmd_set_local_player_id(local_number: int) -> void:  # C# CallCmdSetLocalPlayerID
	pass

func call_cmd_get_local_controller(local_number: int) -> void:  # C# CallCmdGetLocalController
	pass

func call_cmd_set_waiting_for_inventory(waiting: bool) -> void:  # C# CallCmdSetWaitingForInventory
	pass

func call_cmd_enable_0() -> void:  # C# CallCmdEnable
	pass

func call_cmd_disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# CallCmdDisable
	pass

func call_cmd_freeze() -> void:  # C# CallCmdFreeze
	pass

func call_cmd_unfreeze() -> void:  # C# CallCmdUnfreeze
	pass

func call_cmd_pause() -> void:  # C# CallCmdPause
	pass

func call_cmd_unpause() -> void:  # C# CallCmdUnpause
	pass

func call_cmd_hide() -> void:  # C# CallCmdHide
	pass

static func invoke_rpc_rpc_set_sprites(obj, reader) -> void:  # C# InvokeRpcRpcSetSprites
	pass

static func invoke_rpc_rpc_find_local_player(obj, reader) -> void:  # C# InvokeRpcRpcFindLocalPlayer
	pass

static func invoke_rpc_rpc_get_local_controller(obj, reader) -> void:  # C# InvokeRpcRpcGetLocalController
	pass

static func invoke_rpc_rpc_enable(obj, reader) -> void:  # C# InvokeRpcRpcEnable
	pass

static func invoke_rpc_rpc_disable(obj, reader) -> void:  # C# InvokeRpcRpcDisable
	pass

static func invoke_rpc_rpc_freeze(obj, reader) -> void:  # C# InvokeRpcRpcFreeze
	pass

static func invoke_rpc_rpc_unfreeze(obj, reader) -> void:  # C# InvokeRpcRpcUnfreeze
	pass

static func invoke_rpc_rpc_pause(obj, reader) -> void:  # C# InvokeRpcRpcPause
	pass

static func invoke_rpc_rpc_unpause(obj, reader) -> void:  # C# InvokeRpcRpcUnpause
	pass

static func invoke_rpc_rpc_hide(obj, reader) -> void:  # C# InvokeRpcRpcHide
	pass

func call_rpc_set_sprites(animal) -> void:  # C# CallRpcSetSprites
	pass

func call_rpc_find_local_player(local_number: int) -> void:  # C# CallRpcFindLocalPlayer
	pass

func call_rpc_get_local_controller(local_number: int) -> void:  # C# CallRpcGetLocalController
	pass

func call_rpc_enable_0() -> void:  # C# CallRpcEnable
	pass

func call_rpc_disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# CallRpcDisable
	pass

func call_rpc_freeze() -> void:  # C# CallRpcFreeze
	pass

func call_rpc_unfreeze() -> void:  # C# CallRpcUnfreeze
	pass

func call_rpc_pause() -> void:  # C# CallRpcPause
	pass

func call_rpc_unpause() -> void:  # C# CallRpcUnpause
	pass

func call_rpc_hide() -> void:  # C# CallRpcHide
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
