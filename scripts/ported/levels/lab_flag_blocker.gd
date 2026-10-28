# Ported from structur/LabFlagBlocker.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name LabFlagBlocker
extends Node2D

var rend
var coll: CollisionShape2D
@export var interval_time: float

func _ready() -> void:  # C# Start
	pass

func flag_blocker():  # C# FlagBlocker (coroutine)
	pass
