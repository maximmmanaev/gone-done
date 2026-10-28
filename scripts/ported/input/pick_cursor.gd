# Ported from structur/PickCursor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PickCursor
extends CursorUnity

@export var selection_collider: CollisionShape2D
var inventory_book_menu
@export var cursor_point: Node2D
var picked_piece: Node2D
@export var picking: bool
@export var pause_mode: bool
var player_animal
var on_layer: int
var lock_set: bool
static var placement_lock: bool
@export var ignore_direct_pause_events: bool
var accept_down_last_frame: bool
var picked_piece_net_id
static var k_cmd_cmd_pick_piece: int
var pick  # C# property
var networkpicked_piece: Node2D  # C# property
var network_player_animal  # C# property
var networkon_layer: int  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func on_rotate_left() -> void:  # C# OnRotateLeft
	pass

func on_rotate_right() -> void:  # C# OnRotateRight
	pass

func on_back() -> void:  # C# OnBack
	pass

func on_start() -> void:  # C# OnStart
	pass

func on_inventory() -> void:  # C# OnInventory
	pass

func on_accept_0() -> void:  # C# OnAccept
	pass

func deal_with_pickable() -> void:  # C# dealWithPickable
	pass

func set_layer(layer: int, is_server: bool) -> void:  # C# SetLayer
	pass

func enable_0() -> void:  # C# Enable
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func check_hovered_pick_add(c: CollisionShape2D) -> void:  # C# checkHoveredPickAdd
	pass

func try_pick_piece():  # C# tryPickPiece (coroutine)
	pass

func disable_2(sound: bool, show_notebook_sprite: bool) -> void:  # C# Disable
	pass

func clear_hover_pick() -> void:  # C# ClearHoverPick
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func cmd_pick_piece(piece: Node2D) -> void:  # C# CmdPickPiece
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_pick_piece(obj, reader) -> void:  # C# InvokeCmdCmdPickPiece
	pass

func call_cmd_pick_piece(piece: Node2D) -> void:  # C# CallCmdPickPiece
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
