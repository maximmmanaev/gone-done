# Каркас из structur/ProjectileLauncher.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name ProjectileLauncher
extends ActiveBlock

var ammo: Projectile
@export var first_shot_delay: float = 1.0
@export var initial_delay: float
@export var interval: float = 2.4
@export var angle: float
@export var launch_point: Vector3
@export var last_shot: float
@export var sound_event_name: String
var shoot_angle: Quaternion
@export var shoot_animator: AnimationPlayer
@export var shooting: bool
var adjusted_launch_point: Vector3
var projectile_counter: int
var pool: ObjPool

func _ready() -> void:  # C# Start
	pass


func _physics_process(delta: float) -> void:  # C# FixedUpdate
	pass

func act(delta_time: float) -> void:  # C# Act
	var t := play_clock() - first_shot_delay
	if t < 0.0:
		return
	var index := floori(t / interval)
	if index != _last_index:
		_last_index = index
		shoot_projectile_0()




func shoot_projectile_0() -> void:  # C# ShootProjectile
	var arrow := Projectile.new()
	arrow.direction = shoot_dir
	arrow.launched_from = self
	arrow.position = position + shoot_dir * muzzle_offset
	arrow.rotation = shoot_dir.angle() + PI / 2.0
	arrow.add_child(Art.make_arrow())
	arrow.get_child(arrow.get_child_count() - 1).scale = Vector2.ONE * Catalog.K
	get_parent().add_child(arrow)
	shots.append(arrow)

var shoot_dir := Vector2.RIGHT
var muzzle_offset := 12.0
var shots: Array = []
var _last_index := -1


func reset_play_state() -> void:
	_last_index = -1
	for s in shots:
		if is_instance_valid(s):
			s.queue_free()
	shots.clear()
