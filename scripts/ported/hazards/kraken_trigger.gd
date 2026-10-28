# Ported from structur/KrakenTrigger.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name KrakenTrigger
extends Node2D

var tentacles_manager: TentaclesManager
var seconds_between_activations: int
var inactive_color: Color
var player_mask: int
var simulated: bool
var sprite: Sprite2D
var visible_position: Vector3
var base_color: Color
var active: bool
var network_identity
var tween_coroutine
var u_is_playing: bool
static var k_rpc_rpc_trigger_tentacles: int

func _enter_tree() -> void:  # C# Awake
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func rpc_trigger_tentacles(random_seed: int) -> void:  # C# RpcTriggerTentacles
	pass

func trigger_tentacles(random_seed: int):  # C# TriggerTentacles
	pass

func set_active(active: bool, skip_anim: bool) -> void:  # C# SetActive
	pass

func start_tween(end_position: Vector3, time: float, on_complete: Callable) -> void:  # C# StartTween
	pass

func tween_to(end_position: Vector3, time: float, on_complete: Callable):  # C# TweenTo (coroutine)
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_rpc_rpc_trigger_tentacles(obj, reader) -> void:  # C# InvokeRpcRpcTriggerTentacles
	pass

func call_rpc_trigger_tentacles(random_seed: int) -> void:  # C# CallRpcTriggerTentacles
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
