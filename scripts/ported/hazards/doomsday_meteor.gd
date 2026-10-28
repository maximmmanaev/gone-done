# Ported from structur/DoomsdayMeteor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name DoomsdayMeteor
extends Node2D

enum MeteorSizes {
	ExtraSmall = 1,
	Small,
	Medium,
	Large,
	ExtraLarge,
}
@export var speed: float
@export var y_min: float
var u_size

func _ready() -> void:  # C# Start
	pass

func start_meteor_sound() -> void:  # C# StartMeteorSound
	pass

func on_screen_meteor_sound() -> void:  # C# OnScreenMeteorSound
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func get_meteor_size_string() -> String:  # C# GetMeteorSizeString
	return ""
