# Каркас из structur/SawSpinAndMove.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name SawSpinAndMove
extends Node2D

@export var spin_speed: float = 8.0
@export var move_speed: float = 40.0
@export var going_left: bool
@export var going_right: bool
@export var max_left: float = 48.0
@export var max_right: float = 48.0

func _ready() -> void:  # C# Start
	_origin_x = position.x
	if not going_left and not going_right:
		going_right = true

func _process(delta: float) -> void:  # C# Update
	rotation += spin_speed * delta
	var dx := move_speed * delta
	if going_right:
		position.x += dx
		if position.x >= _origin_x + max_right:
			position.x = _origin_x + max_right
			going_right = false
			going_left = true
	elif going_left:
		position.x -= dx
		if position.x <= _origin_x - max_left:
			position.x = _origin_x - max_left
			going_left = false
			going_right = true

var _origin_x := 0.0

var kill_radius := 14.0
var spin_active := false          # убивает только в забеге
var area: Area2D


func _enter_tree() -> void:
	if area:
		return
	area = Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitorable = false
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = kill_radius
	shape.shape = circle
	area.add_child(shape)
	area.body_entered.connect(_on_body)
	add_child(area)


func _on_body(body: Node) -> void:
	if spin_active and body is Character:
		body.kill_character("saw", self)


func _physics_process(_delta: float) -> void:
	if spin_active and area:
		for b in area.get_overlapping_bodies():
			if b is Character:
				b.kill_character("saw", self)

func reset_play_state() -> void:
	position.x = _origin_x
	going_left = false
	going_right = true
