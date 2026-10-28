# Ported from structur/ProtoShape2D.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ProtoShape2D
extends Node2D

var mesh_asset
@export var type: int
var u_points: Array
var points_final: Array
var cpoints: Array
var cpoints_final: Array
@export var triangle_count: int
@export var fill_type: int
@export var texture_scale: float
@export var texture_rotation: float
@export var texture_offset: Vector2
@export var color_1: Color
@export var color_2: Color
@export var gradient_scale: float
@export var gradient_rotation: float
@export var gradient_offset: float
@export var outline_width: float
@export var outline_color: Color
var outline_vertices: Array
@export var outline_loop: bool
@export var outline_connect: int
@export var hdr_colors: bool
var default_material: Material
var sprite_material: Material
var custom_material: Material
@export var u_texture: Texture2D
@export var unique_name: String
@export var curve_iterations: int
@export var antialias: bool
@export var aaridge: float
var aaridge_vertices: Array
@export var sorting_layer: int
@export var order_in_layer: int
@export var snap_type: int
@export var grid_size: float
@export var pivot_position: int
@export var collider_type: int
@export var collider_top_angle: float
@export var collider_offset_top: float
@export var show_normals: bool
var c_mesh
@export var c_mesh_depth: float
var edge_sum: float
@export var clockwise: bool
var mr
var mf
var vertices: Array
var colors: Array
var uvs: Array
var tris: Array
var tris_outline: Array
var last_pos: Vector2
@export var min_point: Vector2
@export var max_point: Vector2
@export var show_fill_settings: bool
@export var show_outline_settings: bool
@export var show_mesh_setting: bool
@export var show_snap_setting: bool
@export var show_collider_settings: bool
@export var show_tools: bool

func _enter_tree() -> void:  # C# Awake
	pass

func setup_shared_mesh() -> void:  # C# setupSharedMesh
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func set_sprite_material_1(mat: Material) -> void:  # C# SetSpriteMaterial
	pass

func set_sprite_material_0() -> void:  # C# SetSpriteMaterial
	pass

func set_default_material() -> void:  # C# SetDefaultMaterial
	pass

func set_custom_material_0() -> void:  # C# SetCustomMaterial
	pass

func set_custom_material_1(mat: Material) -> void:  # C# SetCustomMaterial
	pass

func update_material_settings() -> void:  # C# UpdateMaterialSettings
	pass

func update_mesh() -> void:  # C# UpdateMesh
	pass

func update_collider() -> void:  # C# UpdateCollider
	pass

func get_mesh():  # C# GetMesh
	pass

func generate_handles_0() -> void:  # C# GenerateHandles
	pass

func generate_handles_1(i: int) -> void:  # C# GenerateHandles
	pass

func straighten_handles(i: int) -> void:  # C# StraightenHandles
	pass

func line_intersection_point(l_1s: Vector2, l_1e: Vector2, l_2s: Vector2, l_2e: Vector2) -> Vector2:  # C# LineIntersectionPoint
	return Vector2.ZERO

func calculate_bezier_point(t: float, p_0: Vector3, p_1: Vector3, p_2: Vector3, p_3: Vector3) -> Vector3:  # C# CalculateBezierPoint
	return Vector3.ZERO
