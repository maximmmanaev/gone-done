# Ported from structur/AllowedOnPlatform.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AllowedOnPlatform
extends Node2D

static var windows: int
static var osx: int
static var linux: int
static var xbox: int
static var ps4: int
static var android: int
static var switch: int
static var wegame: int
static var ios: int
static var all: int
@export var allowed_platform: int
@export var on_platform: int
var get_allowed: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass
