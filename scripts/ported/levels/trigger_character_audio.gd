# Ported from structur/TriggerCharacterAudio.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name TriggerCharacterAudio
extends Node2D

@export var audio_event_name: String

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass
