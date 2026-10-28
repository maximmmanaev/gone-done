# Ported from structur/CheckColliding.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CheckColliding
extends ColliderModeControl

@export var colliding: bool
@export var required: bool
@export var anti_required: bool
@export var reverse_attach: bool
var check_tag_mask
var ignore_tag_mask
@export var colliding_last_frame: bool
@export var colliding_object: Node2D
@export var track_all_colliding_characters: bool
var colliding_characters: Array
@export var ignore_picked_up: bool
@export var dont_turn_off_on_play: bool
@export var check_bounds: CollisionShape2D
@export var in_bounds: bool
var last_colliding_piece: Placeable
var last_colliding_object: Node2D
@export var ignore_collision_pieces: bool
var on: bool
@export var u_enabled: bool
var attached_to: Placeable
var tag_comparer
var flipping_placement_layer: bool
var on_colliding_characters_updated: Callable
var colliding_with_attachment: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func re_initialize_tags() -> void:  # C# reInitializeTags
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(add_remove: bool) -> void:  # C# ChangeListener
	pass

func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func enable_0() -> void:  # C# Enable
	pass

func disable_0() -> void:  # C# Disable
	pass

func on_trigger_stay_2d(c: CollisionShape2D) -> void:  # C# OnTriggerStay2D
	pass

func on_collision_stay_2d(c) -> void:  # C# OnCollisionStay2D
	pass

func check_colliding_object(go: Node2D) -> bool:  # C# CheckCollidingObject
	return false

func handle_collision(go: Node2D) -> void:  # C# handleCollision
	pass

func check_is_parent(parent: Placeable, child: Placeable) -> bool:  # C# checkIsParent
	return false

func set_ignore_collision(cc: CheckColliding, ignore: bool) -> void:  # C# SetIgnoreCollision
	pass

func switch_to_mode(new_phase: int, force_update: bool) -> void:  # C# SwitchToMode
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func on_disable() -> void:  # C# OnDisable
	pass

static func should_ignore_collision(a: CheckColliding, b: CheckColliding) -> bool:  # C# ShouldIgnoreCollision
	return false

static func should_ignore_collision_2(a: CheckColliding, b_mask: int) -> bool:  # C# ShouldIgnoreCollision
	return false

static func should_ignore_collision_3(a: CheckColliding, b_tag: String) -> bool:  # C# ShouldIgnoreCollision
	return false
