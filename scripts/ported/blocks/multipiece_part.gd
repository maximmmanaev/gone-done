# Ported from structur/MultipiecePart.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MultipiecePart
extends ActiveBlock

@export var part_sprite: Sprite2D
var main_block: MultipieceBlock
var colliding_with: Node2D  # C# property

func _exit_tree() -> void:  # C# OnDestroy
	pass

func get_total_mass() -> float:  # C# GetTotalMass
	return 0.0
