# Ported from structur/FerrisWheel.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FerrisWheel
extends MultipieceBlock

@export var rotate_speed: float
@export var spinner: Node2D
@export var clockwise: bool
@export var ferris_wheel_sound_event: String
var position_targets: Array
@export var spinner_new: Node2D
var pivots_rb: Array

func activate_0() -> void:  # C# Activate
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func disable_0() -> void:  # C# Disable
	pass

func flip(sprint: bool) -> void:  # C# Flip
	pass

func update_platform_scales() -> void:  # C# UpdatePlatformScales
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass
