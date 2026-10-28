# Ported from structur/UpblowerParticleControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name UpblowerParticleControl
extends Node2D

var psm
@export var start: Node2D
@export var end: Node2D
@export var detector_width: float
var box_dims: Vector2
var distance: float
@export var life_modifier: float
var initial_particle_lifetime: float
var layer_mask
@export var reduce_length_mod: float
var runmode_particla_gradient
var build_mode_particle_gradient
var runmode_particla_gradient_b
var build_mode_particle_gradient_b
var parent_piece: Placeable

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
