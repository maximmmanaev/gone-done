class_name GridOverlay
extends Node2D
## Сетка клеток для фазы строительства (как в UCH): тонкие линии по клеткам, каждая пятая чуть ярче.

const MINOR := Color(1, 1, 1, 0.13)
const MAJOR := Color(1, 1, 1, 0.26)


func _init() -> void:
	z_index = 4          # над уровнем и блоками, под призраком блока (z_index 5)
	visible = false


func _draw() -> void:
	var w := Catalog.GRID_W * Catalog.CELL
	var h := Catalog.GRID_H * Catalog.CELL
	var minor := PackedVector2Array()
	var major := PackedVector2Array()
	for i in Catalog.GRID_W + 1:
		var x := float(i * Catalog.CELL)
		(major if i % 5 == 0 else minor).append_array([Vector2(x, 0), Vector2(x, h)])
	for j in Catalog.GRID_H + 1:
		var y := float(j * Catalog.CELL)
		(major if j % 5 == 0 else minor).append_array([Vector2(0, y), Vector2(w, y)])
	draw_multiline(minor, MINOR, 1.0)
	draw_multiline(major, MAJOR, 1.0)
