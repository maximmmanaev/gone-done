# Каркас из structur/Teleporter.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
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
@export var cool_down_time: float = 0.8
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
var teleport_time: float = 0.15
var chr_in_teleport: Character
var triggers_this_frame: bool
var time_to_teleport: float  # C# property
var blocked: bool  # C# property
var can_teleport: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	super()
	all_teleporters.append(self)

func _exit_tree() -> void:  # C# OnDestroy
	super()
	all_teleporters.erase(self)
	if is_instance_valid(destination) and destination.destination == self:
		destination.destination = null

func _ready() -> void:  # C# Start
	setup_zone(Vector2(14, 14))

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	super(delta)
	cool_down_timer = maxf(cool_down_timer - delta, 0.0)
	if not is_active or paused or not is_live() or not is_instance_valid(destination) or cool_down_timer > 0.0:
		teleport_timer = 0.0
		return
	var rider: Character = null
	for c: Character in zone_characters:
		if is_instance_valid(c) and not c.dead and not c.dying and not c.success:
			rider = c
			break
	if rider == null:
		teleport_timer = 0.0
		return
	teleport_timer += delta
	if teleport_timer >= teleport_time:
		teleport_timer = 0.0
		rider.global_position = destination.global_position
		cool_down_timer = cool_down_time
		destination.cool_down_timer = cool_down_time

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


func wait_for_surrogate_connection():  # C# waitForSurrogateConnection (coroutine)
	pass

func connect_to_another_teleporter(ignore_me: int) -> void:  # C# ConnectToAnotherTeleporter
	pass

func wait_for_new_destination(ignore_me: int):  # C# waitForNewDestination (coroutine)
	pass


func character_teleport_update() -> void:  # C# CharacterTeleportUpdate
	pass

func teleporting_animation():  # C# TeleportingAnimation (coroutine)
	pass



func set_grid_color(c: Color) -> void:  # C# SetGridColor
	pass

func cancel_teleport() -> void:  # C# CancelTeleport
	pass

static func on_character_respawned(chr: Character) -> void:  # C# OnCharacterRespawned
	pass

## Связать с другим телепортом в обе стороны.
func link_to(other: Teleporter) -> void:
	destination = other
	other.destination = self


## Пары по порядку установки: 1↔2, 3↔4, … (одинокий последний ничего не делает).
static func pair_all() -> void:
	var live: Array = all_teleporters.filter(func(t): return is_instance_valid(t) and t.is_inside_tree())
	live.sort_custom(func(a, b): return a.id < b.id)
	for t in live:
		t.destination = null
	for i in range(0, live.size() - 1, 2):
		live[i].link_to(live[i + 1])


func reset_play_state() -> void:
	cool_down_timer = 0.0
	teleport_timer = 0.0
