# Ported from structur/PickableBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PickableBlock
extends Node2D

var animating: bool
@export var animator: AnimationPlayer
@export var play_once: bool
var pick_colliders: Array
var hovered_cursors: Array
var hover_timer: float
var sprite_sort_order
var inventory_book
@export var page_number: int
@export var button_text: Label
var initial_scale: Vector3
var last_cursor: PickCursor
@export var hover_sound_event: String
@export var click_sound_event: String
var u_visible: bool
var paused: bool
var deactivated_in_book: bool
var placeable_prefab: Placeable
var art_sprites: Array
@export var cross_out: Sprite2D
@export var twitch_logo: Sprite2D
var particle_systems: Array
var tablet_particle_material: Material
@export var in_lobby: bool
@export var in_partybox: bool
var sprite_layer: String
@export var party_box_scale: float
@export var art_holder_transform: Node2D
var initials_animator_speed: float
@export var block_probability_scale: float
@export var block_probability_offset: Vector2
@export var play_ui_hover_sound_on: bool
@export var play_ui_select_sound: bool
var force_tint: bool
var force_tint_color: Color
@export var none_default_colors: bool
var initial_colors: Array
@export var start_position: Vector3
@export var find_party_box: bool
@export var use_start_position: bool
@export var is_twitch_item: bool
@export var can_have_custom_color_set: bool
@export var custom_color: Color
@export var damage_level: int
@export var block_serialize_index: int
static var k_cmd_cmd_enable: int
static var k_rpc_rpc_enable: int
var i_hovered_cursors: Array  # C# property
var this_pickable_block: PickableBlock  # C# property
var u_name: String  # C# property
var net_id_value: int  # C# property
var sfx_event_name: String  # C# property
var available: bool  # C# property
var network_visible: bool  # C# property
var network_in_lobby: bool  # C# property
var network_in_partybox: bool  # C# property
var networksprite_layer: String  # C# property
var network_start_position: Vector3  # C# property
var network_find_party_box: bool  # C# property
var network_use_start_position: bool  # C# property
var networkis_twitch_item: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func ensure_serialize_index() -> void:  # C# EnsureSerializeIndex
	pass

func change_listener(add_remove: bool) -> void:  # C# ChangeListener
	pass

func set_initial_scale(new_scale: float) -> void:  # C# setInitialScale
	pass

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func enable_0() -> void:  # C# Enable
	pass

func enable_1(enable: bool) -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func tint() -> void:  # C# Tint
	pass

func play_hover_sound() -> void:  # C# PlayHoverSound
	pass

func on_accept_1(pick_cursor: PickCursor) -> void:  # C# OnAccept
	pass

func on_accept_2(pick_cursor: PickCursor, play_sound: bool) -> void:  # C# OnAccept
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func cmd_enable_1(enable: bool) -> void:  # C# CmdEnable
	pass

func rpc_enable_1(enable: bool) -> void:  # C# RpcEnable
	pass

func deactivate_for_twitch_vote_panel_display() -> void:  # C# DeactivateForTwitchVotePanelDisplay
	pass

func deactivate_item() -> void:  # C# DeactivateItem
	pass

func activate_item() -> void:  # C# ActivateItem
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func change_art_layer(layer_name: String) -> void:  # C# ChangeArtLayer
	pass

func set_text_canvas_order(num: int) -> void:  # C# SetTextCanvasOrder
	pass

func set_frequency(frequency: int, send_network_message: bool, force: bool) -> void:  # C# SetFrequency
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_enable(obj, reader) -> void:  # C# InvokeCmdCmdEnable
	pass

func call_cmd_enable_1(enable: bool) -> void:  # C# CallCmdEnable
	pass

static func invoke_rpc_rpc_enable(obj, reader) -> void:  # C# InvokeRpcRpcEnable
	pass

func call_rpc_enable_1(enable: bool) -> void:  # C# CallRpcEnable
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
