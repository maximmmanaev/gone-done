# Ported from structur/SurfboardHider.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SurfboardHider
extends Node2D

@export var surfboard: Node2D

func show_surfboard() -> void:  # C# ShowSurfboard
	pass

func hide_surfboard() -> void:  # C# HideSurfboard
	pass

func hold_respawn() -> void:  # C# holdRespawn
	pass

func allow_respawn() -> void:  # C# allowRespawn
	pass
