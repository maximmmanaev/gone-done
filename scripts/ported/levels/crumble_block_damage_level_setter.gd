# Ported from structur/CrumbleBlockDamageLevelSetter.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CrumbleBlockDamageLevelSetter
extends Node2D

var pickable_block: PickableBlock
@export var sprite_renderer: Sprite2D
@export var forced_damage_level: int

func _process(delta: float) -> void:  # C# LateUpdate
	pass
