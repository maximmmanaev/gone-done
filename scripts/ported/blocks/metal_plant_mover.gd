# Ported from structur/MetalPlantMover.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MetalPlantMover
extends ActiveBlock

var moving_block_animators: Array
@export var moving_speed: float

func _enter_tree() -> void:  # C# Awake
	pass

func activate_0() -> void:  # C# Activate
	pass

func start_moving_delay():  # C# StartMovingDelay (coroutine)
	pass

func to_place_mode_1(enable_selection: bool) -> void:  # C# ToPlaceMode
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func set_offsets() -> void:  # C# SetOffsets
	pass

func end_play() -> void:  # C# EndPlay
	pass
