# Ported from structur/OriginManager.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name OriginManager
extends Node2D

static var instance: OriginManager
static var initialized: bool
static var blocked_user_ids: Array
static var unlocked_achievements: Array
static var queued_achievement_unlocks: Array
static var achievement_code: String
static var security_key: String
static var content_id: String
static var multiplayer_id: String
@export var use_debug_overlay: bool
var origin_debug_canvas: CanvasLayer
@export var origin_debug_text: Label
@export var debug_port: int
@export var use_debug_port: bool

func _enter_tree() -> void:  # C# Awake
	pass
