# Ported from structur/WinState.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name WinState
extends Node2D

var u_text: Label
@export var win_value: float
@export var beat: bool

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func beat_2() -> void:  # C# Beat
	pass
