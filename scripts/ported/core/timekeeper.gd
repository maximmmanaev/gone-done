# Ported from structur/Timekeeper.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Timekeeper
extends RefCounted

class TimeSource extends RefCounted:
	var u_scale: float
	var slow_duration: float
	var start_time: float
	var paused: bool
static var slowing: bool
static var ramping: bool
static var time_sources: Dictionary
static var sources_to_remove: Array
static var slow_ramp_time: float
static var listening_for_scene: bool
static var any_source_paused: bool  # C# property

static func add_slow_mo_source_4(source: Node2D, scale: float, duration: float, ramp_time: float) -> void:  # C# AddSlowMoSource
	pass

static func add_slow_mo_source_5(source: Node2D, scale: float, duration: float, ramp_time: float, slow_ramp: Curve) -> void:  # C# AddSlowMoSource
	pass

static func remove_slow_mo_source(source: Node2D) -> void:  # C# RemoveSlowMoSource
	pass

static func pause_slow_mo_source(source: Node2D) -> void:  # C# PauseSlowMoSource
	pass

static func unpause_slow_mo_source(source: Node2D) -> void:  # C# UnpauseSlowMoSource
	pass

static func has_source(source: Node2D) -> bool:  # C# HasSource
	return false

static func slow_time(ramp_time: float, slow_ramp: Curve):  # C# slowTime (coroutine)
	pass

static func on_scene_changed(scene, new_scene) -> void:  # C# onSceneChanged
	pass

static func min_scale() -> float:  # C# minScale
	return 0.0

static func timeout_sources() -> void:  # C# timeoutSources
	pass
