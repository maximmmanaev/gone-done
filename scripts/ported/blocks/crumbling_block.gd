# Ported from structur/CrumblingBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CrumblingBlock
extends ActiveBlock

@export var delay: float
@export var fall_delay: float
var fall_time: float
@export var collider_off_delay: float
@export var collided: bool
@export var collide_time: float
@export var real: bool
@export var x_axis_velocity_trigger_value: float
@export var y_axis_velocity_trigger_value: float
@export var main_art_sprite: Sprite2D
var damage_result_delay: bool
var fall_audio_played: bool
@export var block_root_name: String
@export var falling: bool
@export var gravity_value: float
@export var gravity_floor: float
var velocity_y: float
var rb: RigidBody2D
var animator: AnimationPlayer
@export var crumble_particles: GPUParticles2D
@export var particle_color: Color
var art_reference: CrumblingBlockScriptableObject
@export var crumble_fps: float
@export var allow_reset: bool
var surrogate_synced: bool

func _ready() -> void:  # C# Start
	pass

func apply_damage_level_sprite(damage: int) -> void:  # C# ApplyDamageLevelSprite
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func disable_solid_collider() -> void:  # C# DisableSolidCollider
	pass

func character_trigger(chr: Character) -> void:  # C# CharacterTrigger
	pass

func emit_particles():  # C# emitParticles (coroutine)
	pass

func block_hit() -> void:  # C# BlockHit
	pass

func projectile_trigger_0() -> void:  # C# ProjectileTrigger
	pass

func set_initial_damage_level(damage: int, allow_damage_reset: bool) -> void:  # C# SetInitialDamageLevel
	pass

func add_bomb_damage(damage_amount: int) -> void:  # C# AddBombDamage
	pass

func set_damage_level(damage: int) -> void:  # C# SetDamageLevel
	pass

func reset_damage() -> void:  # C# ResetDamage
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
