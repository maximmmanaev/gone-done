# Ported from structur/Jetpack.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Jetpack
extends ActiveBlock

var carrier: Character
var start_position: Vector3
var pickup_requested: bool
var pickup_requester: Character
var animator: AnimationPlayer
var always_respawn: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func activate_0() -> void:  # C# Activate
	pass

func disable_0() -> void:  # C# Disable
	pass

func on_trigger_enter_2d(c: CollisionShape2D) -> void:  # C# OnTriggerEnter2D
	pass

func pickup(chr: Character) -> void:  # C# Pickup
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

static func get_jetpack_from_surrogate_id(id) -> Jetpack:  # C# GetJetpackFromSurrogateID
	return null

func set_carrier(chr: Character) -> void:  # C# SetCarrier
	pass
