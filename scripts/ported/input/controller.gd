# Ported from structur/Controller.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Controller
extends Node2D

# abstract in C#

enum ControllerType {
	KEYBOARD,
	XBOX360,
	XBOXONE,
	PLAYSTATION3,
	PLAYSTATION4,
	GENERIC,
	SWITCH_LEFT,
	SWITCH_RIGHT,
	SWITCH_DUAL,
	SWITCH_FULL,
	SWITCH_HANDHELD,
	MOBILE_TOUCH,
}
var player: int
var receivers: Array
var associated_chars: Array
var assume_user: bool
var use_precise_cursor: bool
var connected: bool
static var locked_input_field
static var just_unlocked: bool
@export var time_since_last_input: float
@export var is_afk: bool
@export var afk_signaler: float
@export var possible_net_work_number: int
static var full_screen_computer_is_active: bool
static var receiver_list_cache: Array
static var null_receiver_cache: Array
static var deferred_input_events: Array
var cleared_receivers: Array
var redirect: Controller
static var global_receivers: Array
static var all_controllers: Array
var is_keyboard: bool  # C# property
var is_touch_input_device: bool  # C# property
var pad_index: int  # C# property
static var input_field_is_active: bool  # C# property
static var input_field_was_active_recently: bool  # C# property

func _ready() -> void:  # C# Start
	pass

var absolute

func _enter_tree() -> void:  # C# Awake
	pass

func assume_user_2(assume: bool) -> void:  # C# AssumeUser
	pass

func is_assuming_user() -> bool:  # C# IsAssumingUser
	return false

func add_player_1(player: int) -> void:  # C# AddPlayer
	pass

func remove_player_1(player: int) -> void:  # C# RemovePlayer
	pass

func get_last_player_number() -> int:  # C# GetLastPlayerNumber
	return 0

func get_last_player_number_after(last_player_number: int) -> int:  # C# GetLastPlayerNumberAfter
	return 0

func clear_players() -> void:  # C# ClearPlayers
	pass

func associate_character(character, player: int) -> void:  # C# AssociateCharacter
	pass

func get_associated_characters() -> Array:  # C# GetAssociatedCharacters
	return []

func controls_player(player: int) -> bool:  # C# ControlsPlayer
	return false

func get_control_mask() -> int:  # C# GetControlMask
	return 0

func add_receiver(r) -> void:  # C# AddReceiver
	pass

func remove_receiver(r) -> void:  # C# RemoveReceiver
	pass

func clear_receivers_0() -> void:  # C# ClearReceivers
	pass

func get_all_receivers() -> Array:  # C# GetAllReceivers
	return []

func clear_receivers_1(keep_global: bool) -> void:  # C# ClearReceivers
	pass

func notify_next_frame(e: InputEventUnity) -> void:  # C# NotifyNextFrame
	pass

func notify(e: InputEventUnity) -> void:  # C# Notify
	pass

func redirect_input_to(target: Controller) -> void:  # C# RedirectInputTo
	pass

func get_first_associated_character():  # C# GetFirstAssociatedCharacter
	pass

func set_precise_cursor(precise: bool) -> void:  # C# SetPreciseCursor
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func u_disconnect(player: PlayerUnity) -> void:  # C# Disconnect
	pass

func u_connect(player: PlayerUnity) -> void:  # C# Connect
	pass

func restore_receivers(p: PlayerUnity, old_controller: Controller) -> void:  # C# RestoreReceivers
	pass

static func add_global_receiver(r) -> void:  # C# AddGlobalReceiver
	pass

static func remove_global_receiver(r) -> void:  # C# RemoveGlobalReceiver
	pass

static func unlock_input_field() -> void:  # C# UnlockInputField
	pass

static func lock_input_field(input_field, on_end_edit: Callable, unlock_on_end_edit: bool) -> void:  # C# LockInputField
	pass

static func set_locked_input_field_internal(input_field) -> void:  # C# SetLockedInputFieldInternal
	pass

static func get_controller_at_pad_index(pad_index: int) -> Controller:  # C# GetControllerAtPadIndex
	return null

static func clear_players_for_all_controllers() -> void:  # C# ClearPlayersForAllControllers
	pass
