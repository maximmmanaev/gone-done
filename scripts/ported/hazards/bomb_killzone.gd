# Ported from structur/BombKillzone.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name BombKillzone
extends Node2D

var in_blast_zone: Array
var killzone_collider: CollisionShape2D
@export var use_custom_tint: bool
@export var tint_color: Color
@export var detect_attachments: bool

func _ready() -> void:  # C# Start
	pass

func add_block(p: Placeable) -> void:  # C# addBlock
	pass

func remove_block(p: Placeable) -> void:  # C# removeBlock
	pass

func handle_collision(c: CollisionShape2D, add: bool) -> void:  # C# HandleCollision
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func on_trigger_exit_2d(c: CollisionShape2D) -> void:  # C# OnTriggerExit2D
	pass

func recalculate_blocks() -> void:  # C# RecalculateBlocks
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass
