# Ported from structur/HarzardKillSound.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name HarzardKillSound
extends Node2D

@export var event_name: String
@export var use_character_game_object: bool

func play_sound_1(character: Character) -> void:  # C# playSound
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
