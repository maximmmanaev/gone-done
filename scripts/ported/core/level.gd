# Ported from structur/Level.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Level
extends Node2D

var this_levelis
@export var start_point: Node2D
@export var start_point_2: Node2D
@export var goal: Node2D
var large_character_spawns: Array
var spectator_start: Array
var spectator_goal: Array
@export var spectator_start_parent: Node2D
@export var spectator_goal_parent: Node2D
@export var cursor_spawn_point: Node2D
@export var cursor_spawn_radius: float
@export var camera_bounds: CollisionShape2D
@export var thumbnail_bounds: CollisionShape2D
@export var cursor_bounds: CollisionShape2D
@export var extra_cursor_bounds: float
@export var starting_blocks: int
@export var max_starting_blocks: int
@export var total_area: float
var delete_pre_unload: Array
var zoomed_out_camera_targets: Array
@export var minimum_character_position: float
@export var max_density: float
@export var min_density: float
var unlock_spawn_locations: Array
var goal_blocks: Array
@export var default_custombackground: int
var current_custom_background: CustomBackground
var current_custom_music
var current_custom_ambience
@export var level_unit_top_buffer: float
@export var level_unit_bottom_buffer: float
@export var level_unit_left_buffer: float
@export var level_unit_right_buffer: float
@export var top: Node2D
@export var bottom: Node2D
@export var left: Node2D
@export var right: Node2D
var computed_total_area: float  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _ready() -> void:  # C# Start
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func add_zoomed_out_camera_target(camera: ZoomCamera, target: Node2D) -> void:  # C# AddZoomedOutCameraTarget
	pass

func add_start_and_goals_to_camera_targets(camera: ZoomCamera) -> void:  # C# AddStartAndGoalsToCameraTargets
	pass

func remove_start_and_goals_from_camera_targets(camera: ZoomCamera) -> void:  # C# RemoveStartAndGoalsFromCameraTargets
	pass

func get_goal_block_by_id(id: int) -> GoalBlock:  # C# GetGoalBlockByID
	return null

func set_background(new_background: int) -> void:  # C# SetBackground
	pass

func enable_placement_bounds(enable: bool) -> void:  # C# EnablePlacementBounds
	pass

func set_music(new_music_from_level) -> void:  # C# SetMusic
	pass

func set_ambience(new_ambience_from_level) -> void:  # C# SetAmbience
	pass

func blank_level_bounds_allowed() -> bool:  # C# BlankLevelBoundsAllowed
	return false

func get_blank_level_bounds() -> AABB:  # C# GetBlankLevelBounds
	return AABB()

func get_camera_bounds() -> AABB:  # C# GetCameraBounds
	return AABB()

func get_thumbnail_bounds() -> AABB:  # C# GetThumbnailBounds
	return AABB()

func get_cursor_bounds() -> AABB:  # C# GetCursorBounds
	return AABB()

static func get_spawn_feet_offset() -> Vector3:  # C# GetSpawnFeetOffset
	return Vector3.ZERO

func get_spawn_position(desired_position: float) -> Vector3:  # C# GetSpawnPosition
	return Vector3.ZERO

func get_large_character_spawn_position(position: int, total_player_count: int) -> Vector3:  # C# GetLargeCharacterSpawnPosition
	return Vector3.ZERO

func spawn_character(c: Character, desired_position: float) -> void:  # C# SpawnCharacter
	pass

func spawn_character_2(c: Character, world_position: Vector3) -> void:  # C# SpawnCharacter
	pass
