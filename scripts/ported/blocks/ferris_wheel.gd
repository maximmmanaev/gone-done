# Каркас из FerrisWheel.cs + логика, написанная вручную.
## Подвижные кабины остаются горизонтальными, пока рама вращается по часам забега.
class_name FerrisWheel
extends MultipieceBlock

@export var rotate_speed := 32.0   # GUESS: градусов в секунду
var clockwise := true
var _radius := 0.0
var _base_angle := 0.0
var _pads: Array[AnimatableBody2D] = []
var _arms: Array[Line2D] = []


func setup_wheel(size: Vector2, rot: int) -> void:
	_radius = minf(size.x, size.y) * 0.37   # GUESS: кабины внутри габарита колеса
	_base_angle = PI / 4.0 + rot * PI / 2.0
	var pad_size := Vector2(Catalog.CELL * 1.5, Catalog.CELL * 0.5)
	for i in 4:
		var arm := Line2D.new()
		arm.width = 2.0
		arm.default_color = Color("#8794a8")
		arm.antialiased = true
		add_child(arm)
		_arms.append(arm)

		var body := AnimatableBody2D.new()
		var collision := CollisionShape2D.new()
		var shape := RectangleShape2D.new()
		shape.size = pad_size
		collision.shape = shape
		body.add_child(collision)
		var art := BlockArt.make("ferris_pad", pad_size)
		if art == null:
			art = Art.make_block("mover", pad_size, Color("#667c9c"))
		body.add_child(art)
		add_child(body)
		_pads.append(body)
	reset_play_state()


func act(_delta: float) -> void:
	var angle := deg_to_rad(rotate_speed) * play_clock()
	_position_pads(angle if clockwise else -angle)


func reset_play_state() -> void:
	_position_pads(0.0)


func _position_pads(angle: float) -> void:
	for i in _pads.size():
		var endpoint := Vector2.RIGHT.rotated(_base_angle + angle + i * PI / 2.0) * _radius
		_pads[i].position = endpoint
		_arms[i].points = PackedVector2Array([Vector2.ZERO, endpoint])
