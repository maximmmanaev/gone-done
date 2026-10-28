# Ported from structur/RotateLights.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RotateLights
extends Node2D

@export var constant_rotate_speed: float
var rotating: bool

func _ready() -> void:  # C# Start
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
