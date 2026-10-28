# Ported from structur/Bomb.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Bomb
extends Placeable

var killzone: BombKillzone
@export var bomb_armed: bool
var bomb_exploded: bool
@export var bomb_sprite: Sprite2D
@export var bomb_animator: AnimationPlayer
@export var explode_sound_string: String
@export var fuse_sound_string: String

func _enter_tree() -> void:  # C# Awake
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func on_explode() -> void:  # C# onExplode
	pass

func disable_0() -> void:  # C# Disable
	pass

func enable_0() -> void:  # C# Enable
	pass

func enable_placement(show_guides: bool) -> void:  # C# EnablePlacement
	pass

func place_3(player_number: int, send_event: bool, force: bool) -> void:  # C# Place
	pass

func place_1(player_number: int) -> void:  # C# Place
	pass

func finish_explode() -> void:  # C# FinishExplode
	pass

func explode_sound() -> void:  # C# ExplodeSound
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass
