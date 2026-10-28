# Ported from structur/ZoomCamera.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ZoomCamera
extends Node2D

enum DeadZoneMode {
	ACTUAL,
	FORCE_ON,
	FORCE_OFF,
}
var inventory_adjust_mode: bool
@export var inventory_aspect_ratio: float
@export var camera_aspect: float
@export var debug_show_calculated: bool
@export var debug_show_frame: bool
@export var debug_show_frame_with_buffer: bool
@export var debug_show_unadjusted_frame: bool
@export var debug_show_boundary: bool
@export var debug_show_dead_zone: bool
@export var manual_controls: bool
@export var manual_zoom: bool
@export var manual_control_speed: float
@export var use_buffer: bool
@export var top_buffer: float
@export var bottom_buffer: float
@export var left_buffer: float
@export var right_buffer: float
var unit_top_buffer: float
var unit_bottom_buffer: float
var unit_left_buffer: float
var unit_right_buffer: float
@export var inventory_left_buffer: float
var current_left_buffer: float
@export var min_frame_height: float
@export var dont_adjust_frame_height: bool
@export var min_frame_height_moving: float
@export var min_frame_height_still: float
@export var build_min_frame_height_moving: float
@export var build_min_frame_height_still: float
@export var moving_to_move_speed: float
@export var moving_to_still_speed: float
@export var difference_threshold: float
var difference: float
var min_frame_width: float
var initial_min_frame_height: float
var initial_min_frame_height_moving: float
var initial_min_frame_height_still: float
var current_phase
@export var use_camera: Camera2D
@export var camera_shaker: AnimationPlayer
var dead_zone: AABB
@export var dead_zone_percentage: Vector2
@export var use_dead_zone: bool
@export var smooth_follow_cam_on: bool
@export var unit_buffer: bool
@export var max_follow_speed: float
var approach_percent: Vector3
@export var min_approach_percent: Vector3
@export var max_approach_percent: Vector3
@export var dist_for_max_approach: Vector3
var distance: Vector3
var targets: Array
var boxes: Array
var characters: Array
var cursors: Array
var follow_target: bool
var boundary: AABB
var u_frame: AABB
var paused: bool
var last_manual_fov: float
var last_manual_position: Vector3
var manual_move_a: Vector4
var manual_move_b: Vector4
var manual_move_time: float
var manual_move_happening: bool
var last_average_of_targets: Vector3
var current_average_of_targets: Vector3
@export var default_center_start: Node2D
static var current_zoom_camera: Camera2D
static var local_only: bool
var force_all_players: bool
var free_form_cam_enabled: bool
var u_width: float  # C# property
var height: float  # C# property
var distance_to_frame: float  # C# property
static var global_camera_time: float  # C# property
static var local_camera_time: float  # C# property

static func reset_timers() -> void:  # C# ResetTimers
	pass

func _enter_tree() -> void:  # C# Awake
	pass

func set_frame_sizes(min_frame_height: float) -> void:  # C# SetFrameSizes
	pass

func _ready() -> void:  # C# Start
	pass

func get_free_form_cam_enabled() -> void:  # C# GetFreeFormCamEnabled
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func update_frame_sizes() -> void:  # C# UpdateFrameSizes
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func manual_camera_move():  # C# ManualCameraMove (coroutine)
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func snap_to_target() -> void:  # C# SnapToTarget
	pass

func zip_to_target(speed: float, zoom_speed: float) -> void:  # C# ZipToTarget
	pass

func zip_to_target_2(speed: float, zoom_speed: float):  # C# zipToTarget (coroutine)
	pass

func set_bounds(bounds: AABB) -> void:  # C# SetBounds
	pass

func get_bounds() -> AABB:  # C# GetBounds
	return AABB()

func add_target(character: Character) -> void:  # C# AddTarget
	pass

func add_target_2(cursor: CursorUnity) -> void:  # C# AddTarget
	pass

func add_target_3(target: Node2D) -> void:  # C# AddTarget
	pass

func add_target_4(box: CollisionShape2D) -> void:  # C# AddTarget
	pass

func remove_target(character: Character) -> void:  # C# RemoveTarget
	pass

func remove_target_2(cursor: CursorUnity) -> void:  # C# RemoveTarget
	pass

func remove_target_3(target: Node2D) -> void:  # C# RemoveTarget
	pass

func remove_target_4(box: CollisionShape2D) -> void:  # C# RemoveTarget
	pass

func has_target(character: Character) -> bool:  # C# HasTarget
	return false

func has_target_2(cursor: CursorUnity) -> bool:  # C# HasTarget
	return false

func has_target_3(target: Node2D) -> bool:  # C# HasTarget
	return false

func has_target_4(target: CollisionShape2D) -> bool:  # C# HasTarget
	return false

func camera_is_in_bounds() -> bool:  # C# CameraIsInBounds
	return false

func clear_targets() -> void:  # C# ClearTargets
	pass

func clear_transform_targets() -> void:  # C# ClearTransformTargets
	pass

func clear_null_elements(list: Array) -> void:  # C# ClearNullElements
	pass

func cleanup_targets() -> void:  # C# cleanupTargets
	pass

func force_frame_update() -> void:  # C# ForceFrameUpdate
	pass

func u_get_frame(with_buffer: bool, adjusted: bool, dead_zone_mode) -> AABB:  # C# GetFrame
	return AABB()

func get_camera_view() -> AABB:  # C# GetCameraView
	return AABB()

func get_fov() -> float:  # C# GetFOV
	return 0.0

func allow_follow(follow: bool) -> void:  # C# AllowFollow
	pass

func shake_camera() -> void:  # C# shakeCamera
	pass

func set_unit_buffer(level: Level) -> void:  # C# SetUnitBuffer
	pass

func set_local_only(local_only: bool) -> void:  # C# SetLocalOnly
	pass

func set_local_only_2(local_only: bool, temp: bool) -> void:  # C# setLocalOnly
	pass

func recheck_local_only() -> void:  # C# RecheckLocalOnly
	pass

func untrack_remote_players() -> void:  # C# untrackRemotePlayers
	pass

func track_all_players() -> void:  # C# trackAllPlayers
	pass

func toggle_local_only() -> bool:  # C# ToggleLocalOnly
	return false

func force_show_all_player(show_all: bool) -> void:  # C# ForceShowAllPlayer
	pass

func any_players_tracked() -> bool:  # C# AnyPlayersTracked
	return false

func handle_event(e) -> void:  # C# handleEvent
	pass
