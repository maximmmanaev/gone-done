# Каркас из BeeSwarm.cs + рисунок и движение, написанные вручную. Конвертер этот файл не трогает.
## Рой: несколько жёлтых точек, дрожащих вокруг центра. Кого касается рой — тот умирает (решает Beehive).
class_name BeeSwarm
extends Node2D

var home_hive: Beehive
var target: Character
var caught: Dictionary
var characters: Array
var disappearing: bool
@export var placed_by_player_number: int
@export var kill_type: String = "bees"
var _t := 0.0
const COUNT := 6


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _draw() -> void:
	for i in COUNT:
		var a := _t * (5.0 + i) + float(i) * 1.7
		var p := Vector2(cos(a), sin(a * 1.3)) * (3.0 + float(i % 3) * 2.0)
		draw_circle(p, 2.2, Color(0.15, 0.12, 0.05))
		draw_circle(p, 1.5, Color(0.98, 0.82, 0.15))
