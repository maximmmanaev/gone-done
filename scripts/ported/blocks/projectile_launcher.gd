# Ported from structur/ProjectileLauncher.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ProjectileLauncher
extends ActiveBlock

var ammo: Projectile
@export var first_shot_delay: float
@export var initial_delay: float
@export var interval: float
@export var angle: float
@export var launch_point: Vector3
@export var last_shot: float
@export var sound_event_name: String
var shoot_angle: Quaternion
@export var shoot_animator: AnimationPlayer
@export var shooting: bool
var adjusted_launch_point: Vector3
var projectile_counter: int
var pool: ObjPool

func _ready() -> void:  # C# Start
	pass

func update_initial_delay() -> void:  # C# UpdateInitialDelay
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func activate_0() -> void:  # C# Activate
	pass

func shoot_projectile_0() -> void:  # C# ShootProjectile
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
