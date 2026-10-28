# Ported from structur/Tweener.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name TweenerUnity
extends RefCounted

var on_finish: Callable

func is_done() -> bool:  # C# IsDone
	return false

func prime() -> void:  # C# Prime
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func animate():  # C# Animate (coroutine)
	pass

func prime_and_animate():  # C# PrimeAndAnimate (coroutine)
	pass

func set_on_finish(on_finish: Callable) -> TweenerUnity:  # C# SetOnFinish
	return null

func finish() -> void:  # C# Finish
	pass
