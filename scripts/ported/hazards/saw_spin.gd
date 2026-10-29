# Каркас из structur/SawSpin.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name SawSpin
extends Node2D

@export var spin_speed: float = 8.0

func _ready() -> void:  # C# Start
	pass

func _process(delta: float) -> void:  # C# Update
	rotation += spin_speed * delta

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
	pass
