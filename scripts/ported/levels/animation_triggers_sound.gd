# Ported from structur/AnimationTriggersSound.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AnimationTriggersSound
extends Node2D

@export var play_sound_as_parent: bool
@export var event_name: String
@export var event_name_b: String
@export var event_name_c: String
@export var event_name_d: String
@export var event_name_e: String
@export var event_name_f: String
@export var go: Node2D
@export var go_b: Node2D
@export var go_c: Node2D
@export var go_d: Node2D
@export var go_e: Node2D
@export var go_f: Node2D
@export var suppress_sounds_after_load_for_seconds: float
@export var can_play_sounds: bool
@export var sound_toggle: bool
var first_sound_played: bool

func _ready() -> void:  # C# Start
	pass

func allow_sounds_after_wait():  # C# AllowSoundsAfterWait (coroutine)
	pass

func play_sound_0() -> void:  # C# playSound
	pass

func play_sound_b() -> void:  # C# playSoundB
	pass

func play_sound_c() -> void:  # C# playSoundC
	pass

func play_sound_d() -> void:  # C# playSoundD
	pass

func play_sound_e() -> void:  # C# playSoundE
	pass

func play_sound_f() -> void:  # C# playSoundF
	pass

func play_sound_2(event_name: String, go: Node2D) -> void:  # C# playSound
	pass
