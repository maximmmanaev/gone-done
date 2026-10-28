# Ported from structur/ModExplosionCharacterForce.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ModExplosionCharacterForce
extends Node2D

@export var center_of_mass: Node2D
var previous_center_of_mass: Vector3
var velocity: Vector3
@export var strength: float
@export var extra_up: float
@export var center_strength_multiplier: float
@export var edge_strength_modifier: float
var animator: AnimationPlayer

func on_trigger_enter_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func _enter_tree() -> void:  # C# Awake
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
