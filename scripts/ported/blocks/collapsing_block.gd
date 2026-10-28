# Ported from structur/CollapsingBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CollapsingBlock
extends ActiveBlock

@export var delay: float
@export var trap_door_animator: AnimationPlayer
@export var collided: bool
@export var collide_time: float
@export var real: bool
var sound_played: bool
@export var vy_trigger_offset: float

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func on_collision_enter_2d(c) -> void:  # C# OnCollisionEnter2D
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
