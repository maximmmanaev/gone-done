class_name Art
extends RefCounted
## Вся графика Gone Done рисуется кодом: закатное небо, крыши, насекомые, блоки.

# ---------- общие помощники ----------

static func ellipse(c: Vector2, rx: float, ry: float, rot := 0.0, n := 24) -> PackedVector2Array:
	var pts := PackedVector2Array()
	for i in n:
		var a := TAU * i / n
		pts.append(c + Vector2(cos(a) * rx, sin(a) * ry).rotated(rot))
	return pts


static func darker(c: Color, k := 0.7) -> Color:
	return Color(c.r * k, c.g * k, c.b * k, c.a)


static func lighter(c: Color, k := 0.35) -> Color:
	return c.lerp(Color.WHITE, k)


# ---------- набор стиля: толстый тёмный контур, объёмная заливка, ржавчина и мох (как на картинках уровней) ----------

const INK := Color(0.10, 0.07, 0.06)
const MOSS := Color(0.45, 0.62, 0.20)
const RUST := Color(0.66, 0.34, 0.14)

## Псевдослучайное число 0..1 по целому ключу (одинаковое при каждой перерисовке).
static func hash01(i: float) -> float:
	return fposmod(sin(i * 12.9898) * 43758.5453, 1.0)


static func outline(ci: CanvasItem, pts: PackedVector2Array, w := 2.6) -> void:
	var closed := pts.duplicate()
	closed.append(pts[0])
	ci.draw_polyline(closed, INK, w, true)


## Закрашенная фигура: свет сверху, тень снизу, тёмный контур.
static func shape(ci: CanvasItem, pts: PackedVector2Array, col: Color, w := 2.6) -> void:
	var y0 := pts[0].y
	var y1 := pts[0].y
	for p in pts:
		y0 = minf(y0, p.y)
		y1 = maxf(y1, p.y)
	var colors := PackedColorArray()
	for p in pts:
		var t := 0.0 if y1 - y0 < 0.001 else (p.y - y0) / (y1 - y0)
		var c := lighter(col, 0.20).lerp(darker(col, 0.74), t)
		c.a = col.a
		colors.append(c)
	ci.draw_polygon(pts, colors)
	if w > 0.0:
		outline(ci, pts, w)


static func rect_shape(ci: CanvasItem, r: Rect2, col: Color, w := 2.6) -> void:
	shape(ci, PackedVector2Array([r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)]), col, w)


static func disc(ci: CanvasItem, c: Vector2, r: float, col: Color, w := 2.6) -> void:
	shape(ci, ellipse(c, r, r, 0.0, 24), col, w)


## Линия с тёмной обводкой.
static func stroke(ci: CanvasItem, a: Vector2, b: Vector2, col: Color, w := 3.0) -> void:
	ci.draw_line(a, b, INK, w + 3.0)
	ci.draw_line(a, b, col, w)


static func rivet(ci: CanvasItem, c: Vector2, r := 2.4) -> void:
	disc(ci, c, r, Color(0.55, 0.55, 0.58), 1.3)
	ci.draw_circle(c + Vector2(-r * 0.3, -r * 0.3), r * 0.35, Color(1, 1, 1, 0.7))


## Крапинки-текстура внутри прямоугольника.
static func speckles(ci: CanvasItem, r: Rect2, col: Color, n: int, seed_i := 0) -> void:
	for i in n:
		var p := r.position + Vector2(hash01(i * 2.0 + seed_i) * r.size.x, hash01(i * 2.0 + 1.0 + seed_i) * r.size.y)
		ci.draw_circle(p, 0.9 + hash01(i + seed_i * 3.0) * 1.0, col)


## Пятна ржавчины.
static func rust(ci: CanvasItem, r: Rect2, n := 3, seed_i := 0) -> void:
	for i in n:
		var c := r.position + Vector2(hash01(i * 3.0 + seed_i) * r.size.x, hash01(i * 3.0 + 1.0 + seed_i) * r.size.y)
		var rx := 2.0 + hash01(i * 3.0 + 2.0 + seed_i) * minf(7.0, r.size.x * 0.25)
		ci.draw_colored_polygon(ellipse(c, rx, rx * 0.6, hash01(i + seed_i) * PI, 10), Color(RUST.r, RUST.g, RUST.b, 0.55))


## Мох по верхней кромке от x0 до x1 на высоте y: бугорки с контуром и пара капель.
static func moss_cap(ci: CanvasItem, x0: float, x1: float, y: float, seed_i := 0) -> void:
	var x := x0
	var k := 0
	while x < x1:
		var w := 8.0 + hash01(k + seed_i) * 8.0
		var h := 3.0 + hash01(k * 1.7 + seed_i) * 3.0
		var pts := ellipse(Vector2(x + w / 2.0, y), w / 2.0, h, 0.0, 10)
		shape(ci, pts, MOSS, 1.6)
		if hash01(k * 2.3 + seed_i) > 0.7:
			ci.draw_line(Vector2(x + w / 2.0, y + h), Vector2(x + w / 2.0, y + h + 4.0 + hash01(k) * 4.0), MOSS.darkened(0.2), 2.0)
		x += w * 0.8
		k += 1



# ---------- насекомые ----------
# Персонаж стоит «столбиком» в коробке 1×2 клетки: примерно x∈[-14, 14], y∈[-30, 30] (ноги на y=30, голова вверху).
# Смотрит вправо; влево его разворачивает scale.x = -1.

class InsectDraw extends Node2D:
	var kind := 0
	var color := Color.WHITE

	func _eye(c: Vector2, r := 4.2) -> void:
		draw_circle(c, r + 1.7, Art.INK)
		draw_circle(c, r, Color.WHITE)
		draw_circle(c + Vector2(r * 0.3, r * 0.1), r * 0.55, Art.INK)
		draw_circle(c + Vector2(r * 0.05, -r * 0.3), r * 0.22, Color.WHITE)

	func _leg(pts: Array, col: Color, w := 3.0) -> void:
		for i in pts.size() - 1:
			draw_line(pts[i], pts[i + 1], Art.INK, w + 2.4)
		for i in pts.size() - 1:
			draw_line(pts[i], pts[i + 1], col, w)

	## Горизонтальная полоса внутри эллипса: нужна полосатому брюшку пчелы.
	func _band(c: Vector2, rx: float, ry: float, y0: float, y1: float, col: Color) -> void:
		var pts := PackedVector2Array()
		for i in 7:
			var y := lerpf(y0, y1, i / 6.0)
			pts.append(Vector2(c.x - rx * sqrt(maxf(0.0, 1.0 - pow((y - c.y) / ry, 2))), y))
		for i in 7:
			var y := lerpf(y1, y0, i / 6.0)
			pts.append(Vector2(c.x + rx * sqrt(maxf(0.0, 1.0 - pow((y - c.y) / ry, 2))), y))
		Art.shape(self, pts, col)

	func _draw() -> void:
		var dark := Art.darker(color, 0.55)
		match kind % 7:
			0:  # жук: большой круглый панцирь с шовчиком, тёмная голова с рожком
				_leg([Vector2(-7, 18), Vector2(-10, 30)], dark)
				_leg([Vector2(2, 21), Vector2(3, 30)], dark)
				_leg([Vector2(9, 17), Vector2(13, 29)], dark)
				Art.shape(self, Art.ellipse(Vector2(-1, 5), 13.5, 17), color)
				draw_line(Vector2(-1, -11), Vector2(-1, 22), dark, 2.0)
				for d in [Vector2(-7, 2), Vector2(5, 8), Vector2(-7, 14)]:
					draw_circle(d, 2.4, dark)
				Art.shape(self, Art.ellipse(Vector2(-6, -3), 3.5, 6.0, 0.3), Art.lighter(color, 0.35))
				Art.shape(self, Art.ellipse(Vector2(4, -19), 9.5, 8.5), dark)
				Art.shape(self, PackedVector2Array([Vector2(5, -26), Vector2(11, -31), Vector2(10, -24)]), dark)
				_eye(Vector2(8, -20), 4.4)
			1:  # кузнечик: узкое тело, длинная согнутая задняя лапа, вытянутая голова и усики
				_leg([Vector2(-6, 10), Vector2(-15, 2), Vector2(-12, 29), Vector2(-6, 29)], dark, 3.4)
				_leg([Vector2(2, 16), Vector2(5, 29)], dark)
				Art.shape(self, Art.ellipse(Vector2(-1, 6), 8.5, 15), color)
				Art.shape(self, Art.ellipse(Vector2(-1, 11), 5.0, 9.0), Art.lighter(color, 0.35))
				Art.shape(self, Art.ellipse(Vector2(-5, 4), 3.5, 12, 0.12), Art.lighter(color, 0.22))
				Art.shape(self, Art.ellipse(Vector2(3, -17), 8, 10), color)
				draw_line(Vector2(2, -26), Vector2(-4, -31), dark, 1.4)
				draw_line(Vector2(6, -26), Vector2(13, -31), dark, 1.4)
				draw_line(Vector2(10, -12), Vector2(6, -11), dark, 1.6)
				_eye(Vector2(7, -20), 4.2)
			2:  # пчела: полосатое пузико, прозрачные крылья, усики с шариками
				var wing := Color(0.85, 0.93, 1.0, 0.75)
				Art.shape(self, Art.ellipse(Vector2(-9, -6), 4.5, 11, -0.35), wing)
				Art.shape(self, Art.ellipse(Vector2(-4, -11), 4.0, 9, 0.2), wing)
				_leg([Vector2(-4, 21), Vector2(-5, 30)], dark)
				_leg([Vector2(4, 21), Vector2(5, 30)], dark)
				Art.shape(self, Art.ellipse(Vector2(0, 8), 11.5, 15), color)
				_band(Vector2(0, 8), 11.5, 15, 3.0, 8.0, Color(0.18, 0.13, 0.10))
				_band(Vector2(0, 8), 11.5, 15, 13.0, 18.0, Color(0.18, 0.13, 0.10))
				Art.shape(self, PackedVector2Array([Vector2(-5, 21), Vector2(-11, 27), Vector2(-2, 24)]), dark)
				Art.shape(self, Art.ellipse(Vector2(4, -16), 9, 8.5), Art.lighter(color, 0.15))
				for t in [Vector2(2, -30), Vector2(13, -29)]:
					draw_line(Vector2(4 if t.x < 5 else 8, -23), t, dark, 1.5)
					draw_circle(t, 1.8, dark)
				_eye(Vector2(8, -17), 4.0)
			3:  # стрекоза: длинное членистое тельце, четыре прозрачных крыла, огромные глаза
				var wing := Color(0.82, 0.93, 1.0, 0.68)
				Art.shape(self, Art.ellipse(Vector2(-11, -13), 12, 3.3, -0.3), wing)
				Art.shape(self, Art.ellipse(Vector2(-12, -7), 12, 3.2, -0.12), wing)
				Art.shape(self, Art.ellipse(Vector2(-1, 14.5), 4.2, 14.5), color)
				for y in [6.0, 11.0, 16.0, 21.0, 26.0]:
					draw_line(Vector2(-5, y), Vector2(3, y), dark, 1.6)
				_leg([Vector2(3, 2), Vector2(5, 12)], dark, 1.8)
				_leg([Vector2(-1, 3), Vector2(-4, 12)], dark, 1.8)
				Art.shape(self, Art.ellipse(Vector2(1, -6), 8, 10), Art.lighter(color, 0.1))
				Art.shape(self, Art.ellipse(Vector2(5, -20), 8.5, 7.5), Art.lighter(color, 0.2))
				_eye(Vector2(8, -21), 5.2)
			4:  # муравей: три сегмента (брюшко, грудка, голова), шесть лапок, усики коленцем
				for lp in [[Vector2(-3, 2), Vector2(-9, 12), Vector2(-9, 29)], [Vector2(1, 4), Vector2(1, 16), Vector2(2, 30)],
						[Vector2(4, 2), Vector2(11, 12), Vector2(13, 29)]]:
					_leg(lp, dark, 2.4)
				Art.shape(self, Art.ellipse(Vector2(-4, 14), 8.5, 12, 0.18), color)
				Art.shape(self, Art.ellipse(Vector2(-6, 11), 3.0, 6.0, 0.18), Art.lighter(color, 0.3))
				Art.shape(self, Art.ellipse(Vector2(1, 0), 5.5, 6.5), Art.lighter(color, 0.08))
				Art.shape(self, Art.ellipse(Vector2(5, -14), 8.5, 7.5), dark)
				_leg([Vector2(7, -20), Vector2(9, -27), Vector2(15, -29)], dark, 1.6)
				_leg([Vector2(3, -20), Vector2(2, -27), Vector2(-3, -30)], dark, 1.6)
				draw_line(Vector2(12, -12), Vector2(16, -9), Art.lighter(color, 0.2), 2.4)   # жвалы
				_eye(Vector2(8, -15), 3.6)
			5:  # бабочка: две пары разноцветных крыльев и тонкое тело
				var wing_a := Art.lighter(color, 0.12)
				var wing_b := Art.lighter(color, 0.38)
				Art.shape(self, Art.ellipse(Vector2(-10, -4), 12.0, 9.0, -0.45), wing_a)
				Art.shape(self, Art.ellipse(Vector2(-9, 8), 9.5, 6.5, 0.5), wing_b)
				draw_circle(Vector2(-12, -6), 3.2, Color(1, 1, 1, 0.85))
				draw_circle(Vector2(-9, 9), 2.4, Color(1, 1, 1, 0.8))
				draw_arc(Vector2(-10, -4), 9.5, PI * 0.9, PI * 1.9, 12, dark, 1.6)
				_leg([Vector2(1, 14), Vector2(1, 30)], dark, 2.0)
				_leg([Vector2(-3, 14), Vector2(-5, 29)], dark, 2.0)
				Art.shape(self, Art.ellipse(Vector2(1, 6), 4.2, 16), dark)
				Art.shape(self, Art.ellipse(Vector2(4, -13), 6.5, 6.5), Art.lighter(dark, 0.25))
				_leg([Vector2(5, -18), Vector2(8, -27), Vector2(13, -30)], dark, 1.4)
				_leg([Vector2(2, -18), Vector2(0, -27), Vector2(-5, -30)], dark, 1.4)
				draw_circle(Vector2(13, -30), 1.7, color)
				draw_circle(Vector2(-5, -30), 1.7, color)
				_eye(Vector2(6, -14), 3.4)
			6:  # светлячок: тёмные надкрылья, светящееся брюшко, тёплое сияние
				draw_circle(Vector2(-1, 17), 15.0, Color(1.0, 0.92, 0.35, 0.22))
				draw_circle(Vector2(-1, 17), 10.5, Color(1.0, 0.92, 0.35, 0.30))
				_leg([Vector2(-5, 20), Vector2(-8, 30)], dark, 2.2)
				_leg([Vector2(4, 20), Vector2(7, 30)], dark, 2.2)
				Art.shape(self, Art.ellipse(Vector2(-1, 17), 7.5, 9.5), Color(1.0, 0.92, 0.40))
				Art.shape(self, Art.ellipse(Vector2(-2, 15), 3.5, 5.0), Color(1.0, 1.0, 0.85))
				Art.shape(self, Art.ellipse(Vector2(-1, 0), 8.5, 13), color)
				draw_line(Vector2(-1, -12), Vector2(-1, 12), dark, 1.6)
				Art.shape(self, Art.ellipse(Vector2(-9, -2), 4.0, 11, 0.25), Color(0.85, 0.93, 1.0, 0.55))
				Art.shape(self, Art.ellipse(Vector2(3, -16), 8.0, 7.5), dark)
				_leg([Vector2(6, -21), Vector2(9, -28)], dark, 1.5)
				_leg([Vector2(2, -21), Vector2(-1, -28)], dark, 1.5)
				_eye(Vector2(7, -17), 3.8)


static func make_insect(kind: int, color: Color) -> Node2D:
	var n := InsectDraw.new()
	n.kind = kind
	n.color = color
	return n


# ---------- блоки ----------

class BlockDraw extends Node2D:
	var type := "plank"
	var size := Vector2(96, 32)
	var color := Color.WHITE

	func _draw() -> void:
		var rect := Rect2(-size / 2.0, size)
		var dark := Art.darker(color, 0.62)
		match type:
			"plank":   # щепка: потёртая доска с прожилками, сучком, гвоздями, мхом сверху
				Art.rect_shape(self, rect, color, 3.0)
				for i in 3:
					var y := rect.position.y + 9.0 + i * 8.0
					draw_line(Vector2(rect.position.x + 5, y), Vector2(rect.end.x - 5 - i * 11, y), dark, 1.4)
				Art.shape(self, Art.ellipse(rect.position + Vector2(rect.size.x * 0.62, rect.size.y * 0.58), 6.5, 4.0, 0.0, 12), Art.darker(color, 0.7), 1.6)
				Art.speckles(self, rect.grow(-4), dark, int(rect.size.x / 5.0), 3)
				Art.rivet(self, rect.position + Vector2(7, 8))
				Art.rivet(self, Vector2(rect.end.x - 7, rect.end.y - 8))
				Art.moss_cap(self, rect.position.x + 2, rect.end.x - 2, rect.position.y + 1, 1)
			"box":     # спичечный коробок: картонный, с этикеткой и тёркой
				Art.rect_shape(self, rect, color, 3.0)
				Art.rect_shape(self, rect.grow(-7), Color(0.93, 0.85, 0.65), 2.2)
				Art.rect_shape(self, Rect2(rect.position.x + 7, rect.position.y + 20, rect.size.x - 14, 14), Color(0.82, 0.25, 0.20), 2.0)
				Art.rect_shape(self, Rect2(rect.end.x - 14, rect.position.y + 2, 12, rect.size.y - 4), Color(0.32, 0.22, 0.17), 2.0)
				Art.speckles(self, Rect2(rect.end.x - 13, rect.position.y + 4, 10, rect.size.y - 8), Color(0.75, 0.45, 0.25), 10, 5)
				Art.rust(self, rect.grow(-6), 2, 2)
				Art.moss_cap(self, rect.position.x + 2, rect.end.x - 2, rect.position.y + 1, 7)
			"pillar":  # карандаш: розовый ластик, металлическая гильза, жёлтое тело с гранью, заточенный низ
				Art.rect_shape(self, rect, color, 3.0)
				Art.rect_shape(self, Rect2(rect.position.x + 2, rect.position.y + 2, rect.size.x - 4, 12), Color(0.93, 0.55, 0.60), 2.0)
				Art.rect_shape(self, Rect2(rect.position.x + 2, rect.position.y + 14, rect.size.x - 4, 7), Color(0.70, 0.72, 0.76), 1.8)
				draw_line(Vector2(rect.position.x + 2, rect.position.y + 17), Vector2(rect.end.x - 2, rect.position.y + 17), Art.INK, 1.2)
				draw_rect(Rect2(rect.position.x + 12, rect.position.y + 22, 4, rect.size.y - 44), Art.darker(color, 0.8))
				Art.shape(self, PackedVector2Array([Vector2(rect.position.x + 2, rect.end.y - 18), Vector2(rect.end.x - 2, rect.end.y - 18), Vector2(0, rect.end.y - 2)]), Color(0.85, 0.68, 0.45), 2.0)
				Art.shape(self, PackedVector2Array([Vector2(-4, rect.end.y - 8), Vector2(4, rect.end.y - 8), Vector2(0, rect.end.y - 2)]), Color(0.2, 0.2, 0.22), 1.2)
				Art.moss_cap(self, rect.position.x + 2, rect.end.x - 2, rect.position.y + 1, 11)
			"mover":   # листок: зелёный, с жилками и мхом по краю
				Art.rect_shape(self, rect, color, 3.0)
				draw_line(Vector2(rect.position.x + 4, 0), Vector2(rect.end.x - 4, 0), Art.darker(color, 0.55), 2.4)
				for i in 5:
					var x := rect.position.x + 14.0 + i * (rect.size.x - 28.0) / 4.0
					draw_line(Vector2(x, 0), Vector2(x - 6, -10), Art.darker(color, 0.7), 1.6)
					draw_line(Vector2(x, 0), Vector2(x - 6, 10), Art.darker(color, 0.7), 1.6)
				Art.speckles(self, rect.grow(-3), Art.lighter(color, 0.3), 14, 9)
				Art.moss_cap(self, rect.position.x + 2, rect.end.x - 2, rect.position.y + 1, 4)
			_:
				Art.rect_shape(self, rect, color, 3.0)


static func make_block(type: String, size: Vector2, color: Color) -> Node2D:
	var n := BlockDraw.new()
	n.type = type
	n.size = size
	n.color = color
	return n


# ---------- указатель у финиша ----------

# ---------- значок поворота (дуговая стрелка) ----------

class RotIconDraw extends Node2D:
	func _draw() -> void:
		var r := 20.0
		var a0 := -PI * 0.8
		var a1 := PI * 0.3
		draw_arc(Vector2.ZERO, r, a0, a1, 24, Color(1, 1, 1, 0.95), 5.0)
		# наконечник по касательной к дуге в конце (направление по часовой)
		var p := Vector2(cos(a1), sin(a1)) * r
		var t := Vector2(-sin(a1), cos(a1))
		var n := Vector2(cos(a1), sin(a1))
		draw_colored_polygon(PackedVector2Array([p + t * 13.0, p + n * 11.0, p - n * 11.0]), Color(1, 1, 1, 0.95))


## Стрелка поворота; против часовой — зеркальное отражение.
static func make_rot_icon(clockwise: bool) -> Node2D:
	var n := RotIconDraw.new()
	if not clockwise:
		n.scale.x = -1.0
	return n


# ---------- бомбы ----------

class BombDraw extends Node2D:
	var type := "bomb"
	var size := Vector2(32, 32)
	var color := Color.WHITE

	func _fuse(from: Vector2, to: Vector2) -> void:
		var mid := from + Vector2(5, -5)
		draw_polyline(PackedVector2Array([from, mid, to]), Art.INK, 5.0)
		draw_polyline(PackedVector2Array([from, mid, to]), Color(0.62, 0.45, 0.25), 2.4)
		draw_circle(to, 5.0, Art.INK)
		draw_circle(to, 3.6, Color(1.0, 0.85, 0.2))     # искра
		draw_circle(to, 1.8, Color(1.0, 1.0, 0.85))

	func _draw() -> void:
		var half := size / 2.0
		match type:
			"dynamite":   # три красные шашки, перевязанные лентой, и фитиль
				for i in 3:
					var x := -11.0 + i * 8.0
					Art.rect_shape(self, Rect2(x, -9, 7, 21), color, 2.2)
					Art.rust(self, Rect2(x, -9, 7, 21), 1, i)
				Art.rect_shape(self, Rect2(-12, -2, 24, 6), Color(0.93, 0.85, 0.62), 1.8)
				_fuse(Vector2(0, -9), Vector2(7, -15))
			"bomb":       # 2×2: чёрная круглая бомба с блеском, ржавой пробкой и фитилём
				var r := minf(half.x, half.y) - 6.0
				Art.disc(self, Vector2(0, 5), r, color, 3.2)
				draw_arc(Vector2(0, 5), r * 0.72, PI * 1.05, PI * 1.55, 10, Color(1, 1, 1, 0.55), 3.0)
				draw_circle(Vector2(-r * 0.35, 5 - r * 0.4), r * 0.12, Color(1, 1, 1, 0.75))
				Art.rect_shape(self, Rect2(-7, 5 - r - 6, 14, 9), Color(0.55, 0.38, 0.28), 2.2)
				Art.rust(self, Rect2(-7, 5 - r - 6, 14, 9), 2, 1)
				_fuse(Vector2(0, 5 - r - 6), Vector2(10, 5 - r - 18))
			"nuke":       # 3×3: жёлтая бочка с обручами, ржавчиной и знаком радиации
				var w := size.x - 10.0
				var h := size.y - 6.0
				var barrel := Rect2(-w / 2.0, -h / 2.0, w, h)
				Art.rect_shape(self, barrel, color, 3.4)
				for yy in [-h * 0.3, h * 0.3]:
					Art.rect_shape(self, Rect2(-w / 2.0, yy - 4.0, w, 8.0), Art.darker(color, 0.78), 2.2)
				Art.rust(self, barrel.grow(-4), 5, 3)
				Art.speckles(self, barrel.grow(-4), Art.darker(color, 0.5), 18, 2)
				var r := minf(w, h) * 0.27
				Art.disc(self, Vector2.ZERO, r * 1.15, Color(0.95, 0.85, 0.3), 2.4)
				for k in 3:
					var a0 := -PI / 2.0 + k * TAU / 3.0 - PI / 6.0
					var pts := PackedVector2Array([Vector2.ZERO])
					for j in 9:
						pts.append(Vector2(cos(a0 + j * (PI / 3.0) / 8.0), sin(a0 + j * (PI / 3.0) / 8.0)) * r)
					draw_colored_polygon(pts, Art.INK)
				Art.disc(self, Vector2.ZERO, r * 0.22, Color(0.95, 0.85, 0.3), 2.0)


## Монета: золотой диск с ободком, ёлочкой по краю и листочком в центре.
class CoinDraw extends Node2D:
	var size := Vector2(32, 32)
	var color := Color(0.98, 0.8, 0.2)

	func _draw() -> void:
		var r := minf(size.x, size.y) * 0.36
		Art.disc(self, Vector2.ZERO, r, color, 3.0)
		draw_arc(Vector2.ZERO, r * 0.78, 0.0, TAU, 28, Color(0.62, 0.42, 0.05), 1.6)
		for k in 14:
			var a := TAU * k / 14.0
			draw_line(Vector2(cos(a), sin(a)) * r * 0.86, Vector2(cos(a), sin(a)) * r * 0.97, Color(0.62, 0.42, 0.05), 1.3)
		Art.shape(self, PackedVector2Array([Vector2(0, -r * 0.5), Vector2(r * 0.34, -r * 0.05), Vector2(r * 0.12, r * 0.45), Vector2(-r * 0.12, r * 0.45), Vector2(-r * 0.34, -r * 0.05)]), Art.darker(color, 0.8), 1.2)
		draw_arc(Vector2.ZERO, r * 0.9, PI * 1.1, PI * 1.5, 8, Color(1, 1, 0.85, 0.9), 2.4)


static func make_coin(size: Vector2, color: Color) -> Node2D:
	var n := CoinDraw.new()
	n.size = size
	n.color = color
	return n


static func make_bomb(type: String, size: Vector2, color: Color) -> Node2D:
	var n := BombDraw.new()
	n.type = type
	n.size = size
	n.color = color
	return n


## Вспышка взрыва: квадратная зона (в которой исчезают постройки) быстро расширяется и гаснет. Рисуется поверх уровня.
class BlastFx extends Node2D:
	var zone_size := Vector2(96, 96)
	var life := 0.0
	var duration := 0.5

	func _process(delta: float) -> void:
		life += delta
		if life >= duration:
			queue_free()
		queue_redraw()

	func _draw() -> void:
		var t := clampf(life / duration, 0.0, 1.0)
		var grow := 1.0 - pow(1.0 - t, 3.0)
		var half := zone_size * (0.35 + 0.65 * grow) / 2.0
		var fade := 1.0 - t
		draw_rect(Rect2(-half, half * 2.0), Color(1.0, 0.7, 0.2, 0.55 * fade))
		draw_rect(Rect2(-half * 0.6, half * 1.2), Color(1.0, 0.95, 0.7, 0.75 * fade))
		draw_rect(Rect2(-half, half * 2.0), Color(1.0, 0.4, 0.15, fade), false, 5.0)
		draw_circle(Vector2.ZERO, minf(half.x, half.y) * 0.9 * grow, Color(1.0, 0.9, 0.5, 0.5 * fade))


static func make_blast(zone_size: Vector2, duration := 0.5) -> Node2D:
	var n := BlastFx.new()
	n.zone_size = zone_size
	n.duration = duration
	n.z_index = 20
	return n


# ---------- ловушки: арбалет, огнемёт, маятник ----------
# Все рисуются «смотрящими вверх»; поворот блока поворачивает картинку целиком.

class TrapDraw extends Node2D:
	var type := "crossbow"
	var size := Vector2(64, 32)
	var color := Color.WHITE
	var arm_px := 0.0          # длина стержня маятника (0 — короткий, для значка)
	var rod_angle := 0.0       # текущий угол качания маятника
	var reach_px := 0.0        # >0: подсказка дальности огня (только у призрака при расстановке)

	func _draw() -> void:
		var dark := Art.darker(color, 0.55)
		match type:
			"crossbow":   # деревянное ложе, изогнутая дуга из жилы, тетива и стрела, нацеленная вверх
				var limb := PackedVector2Array()
				for i in 13:
					var u := i / 12.0
					var x := lerpf(-28.0, 28.0, u)
					limb.append(Vector2(x, 2.0 - 14.0 * (1.0 - pow(2.0 * u - 1.0, 2.0))))
				draw_polyline(limb, Art.INK, 9.0, true)
				draw_polyline(limb, Color(0.50, 0.33, 0.18), 5.0, true)
				Art.stroke(self, Vector2(-28, 2), Vector2(0, 11), Color(0.9, 0.88, 0.8), 1.4)
				Art.stroke(self, Vector2(28, 2), Vector2(0, 11), Color(0.9, 0.88, 0.8), 1.4)
				Art.rect_shape(self, Rect2(-5, -6, 10, 24), color, 2.6)
				Art.speckles(self, Rect2(-4, -4, 8, 20), dark, 6, 4)
				Art.rivet(self, Vector2(0, 14))
				Art.stroke(self, Vector2(0, 11), Vector2(0, -8), Color(0.78, 0.62, 0.40), 2.2)
				Art.shape(self, PackedVector2Array([Vector2(0, -16), Vector2(-5, -8), Vector2(5, -8)]), Color(0.72, 0.74, 0.8), 1.8)
			"flamethrower":   # ржавый баллон с вентилем, соплом и дежурным огоньком
				Art.rect_shape(self, Rect2(-11, -2, 22, 18), color, 2.8)
				Art.rect_shape(self, Rect2(-5, -11, 10, 10), dark, 2.2)
				Art.rect_shape(self, Rect2(-8, 6, 16, 4), Art.darker(color, 0.75), 1.6)
				Art.rust(self, Rect2(-10, -1, 20, 16), 3, 6)
				Art.rivet(self, Vector2(-7, 12))
				Art.rivet(self, Vector2(7, 12))
				Art.shape(self, PackedVector2Array([Vector2(0, -18), Vector2(-4, -11), Vector2(4, -11)]), Color(1.0, 0.6, 0.15), 1.8)
				Art.disc(self, Vector2(0, 2), 2.6, Color(0.9, 0.3, 0.2), 1.4)
				if reach_px > 0.0:
					draw_rect(Rect2(-12, -18.0 - reach_px, 24, reach_px), Color(1.0, 0.5, 0.1, 0.18))
					draw_rect(Rect2(-12, -18.0 - reach_px, 24, reach_px), Color(1.0, 0.5, 0.1, 0.5), false, 1.5)
			"pendulum":   # шарнир, цепь и тяжёлый шар с шипами и заклёпками
				var length := arm_px if arm_px > 0.0 else 22.0
				var tip := Vector2.UP.rotated(rod_angle) * length
				Art.rect_shape(self, Rect2(-10, -5, 20, 10), dark, 2.4)
				var links := maxi(2, int(length / 9.0))
				for k in links:
					var p := tip * (float(k) / links)
					Art.disc(self, p, 3.2, Color(0.55, 0.55, 0.6), 1.6)
				for k in 8:
					var a := TAU * k / 8.0 + rod_angle
					var base := tip + Vector2(cos(a), sin(a)) * 12.0
					Art.shape(self, PackedVector2Array([base + Vector2(cos(a - 0.3), sin(a - 0.3)) * 2.0, tip + Vector2(cos(a), sin(a)) * 19.0, base + Vector2(cos(a + 0.3), sin(a + 0.3)) * 2.0]), Color(0.55, 0.55, 0.6), 1.4)
				Art.disc(self, tip, 13.0, color, 3.0)
				draw_arc(tip, 9.0, PI * 1.1, PI * 1.6, 8, Color(1, 1, 1, 0.5), 2.4)
				Art.rivet(self, tip + Vector2(5, 5), 1.8)
				Art.rivet(self, Vector2.ZERO, 3.2)


static func make_trap(type: String, size: Vector2, color: Color, arm_px := 0.0, reach_px := 0.0) -> Node2D:
	var n := TrapDraw.new()
	n.type = type
	n.size = size
	n.color = color
	n.arm_px = arm_px
	n.reach_px = reach_px
	return n


## Стрела арбалета (смотрит вверх, поворачивается по направлению полёта).
class ArrowDraw extends Node2D:
	func _draw() -> void:
		Art.stroke(self, Vector2(0, 10), Vector2(0, -8), Color(0.78, 0.62, 0.40), 2.6)
		Art.shape(self, PackedVector2Array([Vector2(0, -16), Vector2(-5.5, -7), Vector2(5.5, -7)]), Color(0.72, 0.74, 0.8), 1.8)
		Art.stroke(self, Vector2(0, 10), Vector2(-4.5, 15), Color(0.85, 0.3, 0.3), 2.0)
		Art.stroke(self, Vector2(0, 10), Vector2(4.5, 15), Color(0.85, 0.3, 0.3), 2.0)


static func make_arrow() -> Node2D:
	return ArrowDraw.new()


## Струя огня длиной length вверх от начала координат; мерцает.
class FlameDraw extends Node2D:
	var length := 96.0
	var t := 0.0

	func _process(delta: float) -> void:
		t += delta
		queue_redraw()

	func _draw() -> void:
		var f := 0.9 + 0.1 * sin(t * 38.0)
		var l := length * f
		var outer := PackedVector2Array([Vector2(-12, 0), Vector2(-9, -l * 0.5), Vector2(-3, -l * 0.8), Vector2(0, -l), Vector2(4, -l * 0.78), Vector2(9, -l * 0.5), Vector2(12, 0)])
		draw_colored_polygon(outer, Color(0.95, 0.35, 0.08, 0.9))
		draw_polyline(outer, Color(0.45, 0.12, 0.04, 0.85), 2.4, true)
		var l2 := l * (0.65 + 0.08 * sin(t * 51.0))
		draw_colored_polygon(PackedVector2Array([Vector2(-7, 0), Vector2(-5, -l2 * 0.5), Vector2(0, -l2), Vector2(5, -l2 * 0.5), Vector2(7, 0)]),
			Color(1.0, 0.82, 0.3, 0.95))
		var l3 := l2 * 0.5
		draw_colored_polygon(PackedVector2Array([Vector2(-3, 0), Vector2(0, -l3), Vector2(3, 0)]), Color(1.0, 1.0, 0.85, 0.95))


static func make_flame(length: float) -> Node2D:
	var n := FlameDraw.new()
	n.length = length
	return n


# ---------- шипы, шестерёнка, пружина ----------

class HazardDraw extends Node2D:
	var type := "spikes"
	var size := Vector2(64, 32)
	var color := Color.WHITE

	func _draw() -> void:
		var half := size / 2.0
		match type:
			"spikes":   # чертополох: клочок земли и острые колючки с бликами
				Art.rect_shape(self, Rect2(-half.x, half.y - 8.0, size.x, 8.0), Color(0.36, 0.26, 0.18), 2.4)
				var teeth := int(size.x / 16.0)
				var w := size.x / teeth
				for i in teeth:
					var x0 := -half.x + i * w
					Art.shape(self, PackedVector2Array([Vector2(x0, half.y - 7.0), Vector2(x0 + w * 0.5, -half.y), Vector2(x0 + w, half.y - 7.0)]), color, 2.6)
					draw_line(Vector2(x0 + w * 0.42, half.y - 12.0), Vector2(x0 + w * 0.5, -half.y + 7.0), Art.lighter(color, 0.6), 1.6)
				Art.moss_cap(self, -half.x + 1, half.x - 1, half.y - 8.0, 2)
			"spring":   # пружина: основание, витки и подушка сверху (направление толчка — «вверх» картинки)
				Art.rect_shape(self, Rect2(-half.x + 2, half.y - 8.0, size.x - 4, 8.0), Color(0.34, 0.36, 0.40), 2.4)
				var coil := PackedVector2Array()
				var turns := 4
				for k in turns * 2 + 1:
					var y := lerpf(half.y - 8.0, -half.y + 10.0, float(k) / (turns * 2))
					coil.append(Vector2((half.x - 8.0) * (-1.0 if k % 2 == 0 else 1.0), y))
				draw_polyline(coil, Art.INK, 6.0, true)
				draw_polyline(coil, Color(0.65, 0.68, 0.72), 3.0, true)
				Art.rect_shape(self, Rect2(-half.x + 3, -half.y + 2, size.x - 6, 10), color, 2.6)
				Art.rivet(self, Vector2(-half.x + 9, -half.y + 7), 1.8)
				Art.rivet(self, Vector2(half.x - 9, -half.y + 7), 1.8)
				Art.rust(self, Rect2(-half.x + 3, half.y - 8.0, size.x - 6, 8.0), 1, 8)


## Ржавая шестерёнка (она вращается: поворачивается весь узел).
class SawDraw extends Node2D:
	var radius := 31.0
	var color := Color.WHITE

	func _draw() -> void:
		var teeth := 9
		var pts := PackedVector2Array()
		for i in teeth * 2:
			var a := TAU * i / (teeth * 2.0)
			var r := radius if i % 2 == 0 else radius * 0.76
			pts.append(Vector2(cos(a), sin(a)) * r)
		Art.shape(self, pts, color, 3.0)
		Art.rust(self, Rect2(-radius * 0.6, -radius * 0.6, radius * 1.2, radius * 1.2), 6, 5)
		Art.disc(self, Vector2.ZERO, radius * 0.5, Art.darker(color, 0.8), 2.6)
		Art.disc(self, Vector2.ZERO, radius * 0.22, Color(0.30, 0.22, 0.14), 2.2)
		for k in 6:
			var a := TAU * k / 6.0
			Art.rivet(self, Vector2(cos(a), sin(a)) * radius * 0.36, 1.8)
		draw_line(Vector2(-radius * 0.5, 0), Vector2(-radius * 0.2, 0), Art.INK, 2.4)    # засечка, по которой видно вращение


static func make_hazard(type: String, size: Vector2, color: Color) -> Node2D:
	if type == "saw":
		var saw := SawDraw.new()
		saw.radius = minf(size.x, size.y) / 2.0 - 1.0
		saw.color = color
		return saw
	var n := HazardDraw.new()
	n.type = type
	n.size = size
	n.color = color
	return n


# ---------- блоки из scripts/ported (лёд, мёд, яд, пила на рельсе, топор, ветер) ----------

class PortedDraw extends Node2D:
	var type := ""
	var size := Vector2(16, 16)
	var color := Color.WHITE
	var angle := 0.0          # вращение пилы
	var show_blade := true    # у пилы на рельсе диск рисует сам подвижный узел, рельса — только направляющую

	func _draw() -> void:
		var r := Rect2(-size / 2.0, size)
		match type:
			"ice":
				Art.rect_shape(self, r, color)
				for i in 3:
					var x := r.position.x + size.x * (0.2 + 0.3 * i)
					draw_line(Vector2(x, r.position.y + 3), Vector2(x + 7, r.position.y + size.y - 4), Color(1, 1, 1, 0.75), 1.6)
			"honey":
				Art.rect_shape(self, r, color)
				for i in int(size.x / 16.0):
					var x := r.position.x + 8.0 + i * 16.0
					Art.disc(self, Vector2(x, r.end.y - 1.0), 3.5, Art.lighter(color, 0.15), 1.6)
			"toxic":
				Art.rect_shape(self, Rect2(r.position + Vector2(0, size.y * 0.35), Vector2(size.x, size.y * 0.65)), color)
				for i in int(size.x / 12.0):
					Art.disc(self, Vector2(r.position.x + 7.0 + i * 12.0, r.position.y + size.y * 0.5), 3.0, Art.lighter(color, 0.3), 1.4)
			"sawrail":
				Art.stroke(self, Vector2(r.position.x + 4, 0), Vector2(r.end.x - 4, 0), Color(0.45, 0.45, 0.5), 3.0)
				if show_blade:
					_blade(Vector2(r.position.x + size.y / 2.0, 0), size.y / 2.0)
			"sawblade":
				_blade(Vector2.ZERO, size.y / 2.0)
			"axearm":
				Art.stroke(self, Vector2(0, 0), Vector2(0, size.y - 8), Color(0.45, 0.35, 0.25), 3.0)
				Art.disc(self, Vector2(0, size.y - 6), 8.0, color, 2.2)
			"axe":
				Art.disc(self, Vector2.ZERO, 3.0, Color(0.35, 0.35, 0.4), 1.6)
			"wind":    # стрелки смотрят вверх: блок без поворота дует вверх
				for col in 3:
					var x := r.position.x + size.x * (0.2 + 0.3 * col)
					draw_line(Vector2(x, r.end.y - 4), Vector2(x, r.position.y + 4), Color(color, 0.7), 2.4)
					draw_colored_polygon(PackedVector2Array([Vector2(x, r.position.y + 4), Vector2(x - 5, r.position.y + 14), Vector2(x + 5, r.position.y + 14)]), Color(color, 0.8))
				draw_rect(r, Color(color, 0.12))
				draw_rect(r, Color(color, 0.5), false, 1.5)

	func _blade(c: Vector2, rad: float) -> void:
		Art.disc(self, c, rad - 1.0, color, 2.2)
		for k in 8:
			var a := angle + k * PI / 4.0
			draw_line(c, c + Vector2(cos(a), sin(a)) * (rad - 2.0), Art.INK, 2.0)

	func _process(delta: float) -> void:
		if type == "sawrail" or type == "sawblade":
			angle += delta * 10.0
			queue_redraw()


static func make_ported(type: String, size: Vector2, color: Color) -> Node2D:
	var n := PortedDraw.new()
	n.type = type
	n.size = size
	n.color = color
	return n
