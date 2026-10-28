# Ported from structur/PunchingBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PunchingBlock
extends ActiveBlock

@export var glove_animator: AnimationPlayer
var triggers: Array
var trigger_touched: bool
var punching: bool
const PROJECTILE_GRACE_TIME: float = 0.5
var projectile_grace_timer: float
@export var pusher_collider: CollisionShape2D
@export var projectile_collider: CollisionShape2D

func on_trigger_touched() -> void:  # C# OnTriggerTouched
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func punch(locally_triggered: bool) -> void:  # C# Punch
	pass

func on_punch_anim_finished() -> void:  # C# OnPunchAnimFinished
	pass

func enable_hazard() -> void:  # C# EnableHazard
	pass

func disable_hazard() -> void:  # C# DisableHazard
	pass

func get_hit_trigger_mask() -> int:  # C# GetHitTriggerMask
	return 0

func animate_masked_triggers(mask: int) -> void:  # C# AnimateMaskedTriggers
	pass

func on_projectile_touched_trigger_1(trigger: PunchingBlockTrigger) -> void:  # C# OnProjectileTouchedTrigger
	pass

func process_trigger_message(msg: MsgPunchingBlockTriggered) -> void:  # C# ProcessTriggerMessage
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
