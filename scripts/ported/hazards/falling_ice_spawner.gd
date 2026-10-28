# Ported from structur/FallingIceSpawner.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FallingIceSpawner
extends Node2D

var falling_ice_prefabs: Array
@export var start_point: Node2D
@export var end_point: Node2D
@export var average_period: float
@export var random_range: float
@export var shooter_timer: float
@export var max_rotate_speed: float
@export var min_scale: float
@export var max_scale: float
static var k_cmd_cmd_spawn_ice_block: int
static var k_rpc_rpc_spawn_ice_block: int
var paused: bool  # C# property
var scoreboard: bool  # C# property

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func cmd_spawn_ice_block() -> void:  # C# CmdSpawnIceBlock
	pass

func rpc_spawn_ice_block(ice_type: int, position: Vector3, rotation: float, rotate_speed: float, scale: float) -> void:  # C# RpcSpawnIceBlock
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_cmd_cmd_spawn_ice_block(obj, reader) -> void:  # C# InvokeCmdCmdSpawnIceBlock
	pass

func call_cmd_spawn_ice_block() -> void:  # C# CallCmdSpawnIceBlock
	pass

static func invoke_rpc_rpc_spawn_ice_block(obj, reader) -> void:  # C# InvokeRpcRpcSpawnIceBlock
	pass

func call_rpc_spawn_ice_block(ice_type: int, position: Vector3, rotation: float, rotate_speed: float, scale: float) -> void:  # C# CallRpcSpawnIceBlock
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
