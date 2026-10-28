# Ported from structur/LightCell.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name LightCell
extends Node2D

enum State {
	OFF,
	LIT,
	SOLID,
}

enum Neighbour {
	TOP = 1,
	RIGHT = 2,
	BOTTOM = 4,
	LEFT = 8,
}
var all_neighbours
var cell_state
@export var colour_fade_time: float
@export var trigger_radius: float
@export var default_colour: Color
@export var cycle_offset: float
var filled_sprites: Array
var empty_sprites: Array
@export var x_pos: int
@export var y_pos: int
var grid: LightGrid
@export var fade_time: float
var fade_curve: Curve
var fading: bool
@export var pulse_period: float
var lit_pulse_curve: Curve
var unlit_pulse_curve: Curve
var pulsing: bool
var sprite_renderer: Sprite2D
var box_collider: CollisionShape2D
var colour_lerp: float
var lerp_target: float
var neighbours: int
var anim_time: float
var anim_length: float
var collision_tag: CollisionTag
var solid_object_tag
var non_solid_object_tag

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func pulse_cell() -> void:  # C# pulseCell
	pass

func animate_state_transition(reverse: bool):  # C# AnimateStateTransition (coroutine)
	pass

func turn_on(color: Color) -> void:  # C# TurnOn
	pass

func solidify() -> void:  # C# Solidify
	pass

func turn_off() -> void:  # C# TurnOff
	pass

func set_neighbour(neighbour, lit: bool) -> void:  # C# SetNeighbour
	pass

func set_sprite() -> void:  # C# setSprite
	pass

func fade_to_colour(color: Color, time: float):  # C# fadeToColour (coroutine)
	pass
