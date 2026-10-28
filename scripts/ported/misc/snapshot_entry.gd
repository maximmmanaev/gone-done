# Ported from structur/SnapshotEntry.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SnapshotEntry
extends Node2D

var input_field
@export var level_name_text: Label
@export var code_text: Label
@export var background_image: TextureRect
@export var fave_star: TextureRect
@export var fave_star_back: TextureRect
@export var thumbnail_image: TextureRect
@export var spinny_loading_thing: Sprite2D
@export var public_mark: TextureRect
@export var has_mods_mark: TextureRect
@export var report_count: Label
@export var info_line_1: Label
var name_tag_1
@export var info_line_2: Label
var name_tag_2
var canvas_group
@export var tip_level_name_text: Label
@export var tip_name_tag_line: Node2D
var tip_name_tag
@export var tip_info_line_container: Node2D
var tip_text_info_line_prefab
@export var tip_initialized: bool
var featured_level_data
@export var index_on_current_page: int
var internal_name: String
var code: String
var local: bool
var level_type
var fade_coroutine
var waiting_for_thumbnail_hash: String
var snapshot_name: String  # C# property
var uncensored_name: String  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func set_info_internal(code: String, internal_name: String, local: bool) -> void:  # C# SetInfoInternal
	pass

func set_code(code: String, local: bool) -> void:  # C# SetCode
	pass

func get_on_thumbnail_found(hash: String) -> Callable:  # C# GetOnThumbnailFound
	return Callable()

func mark_file_missing() -> void:  # C# MarkFileMissing
	pass

func fade_in_image(time: float):  # C# FadeInImage (coroutine)
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func initialize_2(data, show_published_mark: bool) -> void:  # C# Initialize
	pass

func populate_info_line(info_line: Label, name_tag, info_line_type) -> void:  # C# PopulateInfoLine
	pass

func on_show_tip(show: bool) -> void:  # C# OnShowTip
	pass

func add_tip_info_line(key: String, value: String) -> void:  # C# AddTipInfoLine
	pass

func split_at_colon(input: String) -> Array:  # C# SplitAtColon
	return []

func clear_tip() -> void:  # C# ClearTip
	pass
