# Ported from structur/AutoDoor.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AutoDoor
extends ActiveBlock

@export var door_collider: CollisionShape2D
var door_collider_cmc: CheckColliding
@export var door_animator: AnimationPlayer
@export var interval: float
var timer: float
var open: bool
var real: bool
var collider_enabled: bool
@export var push_out_point_left: Node2D
@export var timed: bool
var movement_detector: CheckColliding
@export var beam_art_sprite_index: int
@export var door_hazard: CollisionShape2D
@export var door_hazard_delay: float
var door_hazard_enabled: bool

func _ready() -> void:  # C# Start
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func update_character_detection(delta_time: float) -> void:  # C# UpdateCharacterDetection
	pass

func on_detected_characters_updated() -> void:  # C# OnDetectedCharactersUpdated
	pass

func has_any_characters() -> bool:  # C# HasAnyCharacters
	return false

func has_moving_character() -> bool:  # C# HasMovingCharacter
	return false

func on_triggered_by_network() -> void:  # C# OnTriggeredByNetwork
	pass

func on_triggered() -> void:  # C# OnTriggered
	pass

func play_open_sound() -> void:  # C# PlayOpenSound
	pass

func play_close_sound() -> void:  # C# PlayCloseSound
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func enable_door_collider() -> void:  # C# enableDoorCollider
	pass

func disable_door_collider() -> void:  # C# disableDoorCollider
	pass

func set_door_collider_enabled(val: bool) -> void:  # C# SetDoorColliderEnabled
	pass

func delay_door_hazard():  # C# delayDoorHazard (coroutine)
	pass

func push_out_characters() -> void:  # C# PushOutCharacters
	pass

func push_out_character(chr: Character) -> void:  # C# PushOutCharacter
	pass

func on_draw_gizmos() -> void:  # C# OnDrawGizmos
	pass

func on_projectile_touched_trigger_0() -> void:  # C# OnProjectileTouchedTrigger
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func tint() -> void:  # C# Tint
	pass
