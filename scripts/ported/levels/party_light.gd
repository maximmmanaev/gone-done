# Ported from structur/PartyLight.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PartyLight
extends RefCounted

var light: Light2D
var target_light_intensity: float
var initial_light_intensity: float
var current_light_intensity: float
var target_light_color: Color
var initial_light_color: Color
var current_light_color: Color
var targetlight_cookie_size: float
var initial_light_cookie_size: float
var current_light_cookie_size: float
var change_time: float
var coroutine_lock: bool

func set_initial_light() -> void:  # C# setInitialLight
	pass

func set_light(t: float) -> void:  # C# setLight
	pass
