# Ported from structur/FlippingBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FlippingBlock
extends ActiveBlock

@export var bottom_collider: CollisionShape2D
@export var hazard_collider: CollisionShape2D
@export var interval: float
@export var flipping_block_animator: AnimationPlayer
var timer: float
var solid: bool

func _enter_tree() -> void:  # C# Awake
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass
