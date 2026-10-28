# Ported from structur/AnimationTriggersSoundLimited.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AnimationTriggersSoundLimited
extends AnimationTriggersSound

@export var limit_recurrence: bool
@export var do_not_play_time: float
static var donot_play: bool

func play_sound_0() -> void:  # C# playSound
	pass

func wait_till_next_play():  # C# WaitTillNextPlay (coroutine)
	pass
