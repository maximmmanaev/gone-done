# Ported from structur/Teleporter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Teleporter
extends ActiveBlock

var destination: Teleporter
@export var u_ready: bool
@export var triggered_locally: bool
@export var force_off: bool
@export var grid: Sprite2D
@export var portal_animator: AnimationPlayer
@export var teleport_position: Node2D
@export var teleport_target_range: float
var send_particle_prefab
@export var cool_down_time: float
var cool_down_timer: float
var color_options: Array
static var last_color_used: Color
var inside_game_objects: Array
var recently_reset: bool
var last_position: Vector3
var last_world_offset: Vector3
var startup_linked_teleporter: Teleporter
@export var prevent_auto_connect_on_spawn: bool
static var all_teleporters: Array
var teleport_timer: float
var teleport_time: float
var chr_in_teleport: Character
var triggers_this_frame: bool
var time_to_teleport: float  # C# property
var blocked: bool  # C# property
var can_teleport: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func _ready() -> void:  # C# Start
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func is_player(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsPlayer
	return false

func is_body(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsBody
	return false

func is_blocker(obj: Node2D, collision_tag: CollisionTag) -> bool:  # C# IsBlocker
	return false

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func spawn_projectile_send_particle(position: Vector3) -> void:  # C# SpawnProjectileSendParticle
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func act_teleport(delta_time: float) -> void:  # C# ActTeleport
	pass

func set_ready_true() -> void:  # C# setReadyTrue
	pass

func activate_sound() -> void:  # C# activateSound
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func wait_for_surrogate_connection():  # C# waitForSurrogateConnection (coroutine)
	pass

func connect_to_another_teleporter(ignore_me: int) -> void:  # C# ConnectToAnotherTeleporter
	pass

func wait_for_new_destination(ignore_me: int):  # C# waitForNewDestination (coroutine)
	pass

func destroy_self_3(destroy_children: bool, use_smoke: bool, send_network_signal: bool) -> void:  # C# DestroySelf
	pass

func character_teleport_update() -> void:  # C# CharacterTeleportUpdate
	pass

func teleporting_animation():  # C# TeleportingAnimation (coroutine)
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func set_grid_color(c: Color) -> void:  # C# SetGridColor
	pass

func cancel_teleport() -> void:  # C# CancelTeleport
	pass

static func on_character_respawned(chr: Character) -> void:  # C# OnCharacterRespawned
	pass
