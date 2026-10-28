# Ported from structur/LightGrid.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name LightGrid
extends Node2D

@export var grid_size: CollisionShape2D
var light_cell_prefab: LightCell
@export var trigger_radius: float
var cells
var reference_corner: Vector2
var u_width: int
var height: int
var rpc_cell_array: Array
static var k_rpc_rpc_report_solid_cells: int

func _enter_tree() -> void:  # C# Awake
	pass

func _ready() -> void:  # C# Start
	pass

func on_trigger_stay_2d(collision: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func notify_neighbours(cell: LightCell) -> void:  # C# NotifyNeighbours
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func rpc_report_solid_cells(cells_solid: Array) -> void:  # C# RpcReportSolidCells
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

static func invoke_rpc_rpc_report_solid_cells(obj, reader) -> void:  # C# InvokeRpcRpcReportSolidCells
	pass

func call_rpc_report_solid_cells(cells_solid: Array) -> void:  # C# CallRpcReportSolidCells
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
