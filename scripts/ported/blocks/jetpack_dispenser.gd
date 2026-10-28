# Ported from structur/JetpackDispenser.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name JetpackDispenser
extends ActiveBlock

@export var jetpacks_per_round: int
@export var infinite_jetpacks: bool
@export var jetpack_cooldown: float
var jetpack_prefab: Jetpack
@export var jetpack_spawn_point: Node2D
@export var animator: AnimationPlayer
@export var fake_jetpack: Sprite2D
var time_since_last_jetpack: float
var jetpacks_left: int
var current_jetpack: Jetpack
var dispense_hash: int
var reset_hash: int
var first_jet_pack: bool
var last_net_i_dof_jetpack: int

func _enter_tree() -> void:  # C# Awake
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func to_place_mode_1(enable_selection: bool) -> void:  # C# ToPlaceMode
	pass

func activate_0() -> void:  # C# Activate
	pass

func reveal_dispense_jet_pack() -> void:  # C# RevealDispenseJetPack
	pass

func destroy_self_3(destroy_children: bool, use_smoke: bool, send_network_signal: bool) -> void:  # C# DestroySelf
	pass
