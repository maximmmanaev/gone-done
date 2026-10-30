class_name Catalog
extends RefCounted
## Общие данные клиента и сервера: фазы, сетка, уровень, каталог блоков.

enum Phase { LOBBY, PICK, PLACE, RUN, RESULT, OVER }

const CELL := 16
const GRID_W := 80
const GRID_H := 40

# Четыре карты — картинки уровней 1–4 (векторный рисунок assets/levels/levelN.vec лежит фоном; исходные картинки — tools/level_source), в клетках по сетке 80×40 (клетка 16 px, персонаж 1,8 клетки). Зеркало MAPS в
# cloudflare/src/catalog.js. rects — невидимая земля и платформы ровно по нарисованному; последняя — финишная крыша под флагом
# (goal — клетка флага). spawn — клетка старта (земля на строку ниже). hazards — зоны, убивающие при касании (шипы, слизь).
const MAPS := [
	{"name": "Пруд", "spawn": Vector2i(4, 26), "goal": Vector2i(74, 10),
		"rects": [Rect2i(0, 27, 24, 13), Rect2i(22, 22, 14, 2), Rect2i(42, 20, 14, 2), Rect2i(58, 22, 8, 2), Rect2i(52, 27, 14, 13), Rect2i(64, 11, 16, 29)],
		"hazards": []},
	{"name": "Лес", "spawn": Vector2i(4, 30), "goal": Vector2i(74, 10),
		"rects": [Rect2i(0, 31, 18, 9), Rect2i(12, 27, 16, 2), Rect2i(16, 22, 14, 5), Rect2i(6, 13, 18, 2), Rect2i(34, 24, 8, 1), Rect2i(44, 27, 16, 2), Rect2i(58, 13, 6, 2), Rect2i(66, 22, 8, 2), Rect2i(18, 36, 62, 4), Rect2i(52, 35, 16, 1), Rect2i(66, 11, 14, 4)],
		"hazards": [Rect2i(20, 33, 32, 3)]},
	{"name": "Болото", "spawn": Vector2i(4, 30), "goal": Vector2i(74, 6),
		"rects": [Rect2i(0, 31, 16, 9), Rect2i(14, 22, 18, 2), Rect2i(34, 11, 12, 2), Rect2i(34, 18, 16, 2), Rect2i(56, 15, 10, 1), Rect2i(50, 22, 8, 2), Rect2i(16, 33, 14, 2), Rect2i(36, 35, 24, 1), Rect2i(62, 7, 18, 8)],
		"hazards": []},
	{"name": "Свалка", "spawn": Vector2i(4, 30), "goal": Vector2i(74, 6),
		"rects": [Rect2i(0, 31, 24, 9), Rect2i(26, 7, 12, 2), Rect2i(16, 15, 14, 1), Rect2i(24, 20, 8, 2), Rect2i(20, 25, 10, 2), Rect2i(36, 16, 6, 2), Rect2i(34, 24, 10, 1), Rect2i(44, 13, 12, 2), Rect2i(56, 16, 16, 2), Rect2i(60, 20, 8, 7), Rect2i(56, 27, 6, 2), Rect2i(58, 31, 12, 9), Rect2i(52, 33, 6, 2), Rect2i(66, 7, 14, 6)],
		"hazards": [Rect2i(24, 35, 34, 5), Rect2i(72, 31, 8, 9)]},
]

static func spawn_cell(map: int) -> Vector2i:
	return MAPS[map].spawn


static func goal_cell(map: int) -> Vector2i:
	return MAPS[map].goal


## Запретные для строительства зоны над стартом и над флагом (5 клеток вверх, 6 в ширину, не выше края сетки).
static func reserved_rects(map: int) -> Array:
	var out := []
	for pair in [[MAPS[map].spawn, 4], [MAPS[map].goal, 6]]:
		var c: Vector2i = pair[0]
		var y := maxi(0, c.y - 8)
		out.append(Rect2i(c.x - pair[1], y, 12, c.y - y + 1))
	return out

# Размер персонажа: 1,8 клетки в высоту и 0,875 в ширину (проходит в проём в 1 клетку).
const PLAYER_SIZE := Vector2(14, 28.8)
# Во сколько раз мир стал мельче прежнего (клетка 32 → 16 px): на него умножены скорости и размеры в пикселях.
const K := 0.5
const INSECT_K := 28.8 / 60.0   # рисунок насекомого рассчитан на рост 60 px

# Игрок = насекомое: скин (индекс 0..6) выбирает вид и цвет; в комнате каждый скин занимает один игрок.
const INSECT_NAMES := ["Жук", "Кузнечик", "Пчела", "Стрекоза", "Муравей", "Бабочка", "Светлячок"]
const PLAYER_COLORS := [
	Color(0.62, 0.30, 0.28),   # жук
	Color(0.50, 0.74, 0.28),   # кузнечик
	Color(0.97, 0.78, 0.20),   # пчела
	Color(0.30, 0.62, 0.85),   # стрекоза
	Color(0.50, 0.28, 0.20),   # муравей
	Color(0.88, 0.45, 0.72),   # бабочка
	Color(0.32, 0.36, 0.48),   # светлячок
]

# kind: solid — платформа, hazard — убивает, spring — подбрасывает, mover — ездит влево-вправо (повёрнутый — вверх-вниз),
# coin — монета (кто дошёл до флага с монетой, получает очки), bomb — взрывается, shooter — стреляет стрелами, flame — выпускает огонь, pendulum — качающийся шар.
#
# Бомбы (набор зеркалится в BOMBS в cloudflare/src/catalog.js, его сверяет тест): взрываются сразу при установке
# и насовсем сносят постройки в зоне — это сами клетки бомбы (динамит 1×1, бомба 2×2, ядерная 3×3). Взрывом управляет сервер.
# Ловушки-стрелки, огнемёт и маятник считает каждый клиент по часам забега (как листок); направление — куда «смотрит» блок
# (0 — вверх, 1 — вправо, 2 — вниз, 3 — влево), убивает того, кого коснётся; очки за такую смерть получает хозяин ловушки.
# Логику всех этих блоков ведут классы из scripts/ported; PORTED_ART — те, чьи картинки рисует Art.PortedDraw (остальные — старые рисунки).
const PORTED_KINDS := ["ice", "honey", "toxic", "sawrail", "wind", "teleporter", "treadmill", "upblower", "boulder", "blackhole",
	"goal", "sawslide", "sawspin", "spring", "coin", "mover", "shooter", "flame", "pendulum", "crumble", "autodoor", "punch", "hockey", "cannon", "beehive", "pressure", "hydrant", "flipper", "rotator", "lift", "plant"]
const PORTED_ART := ["ice", "honey", "toxic", "sawrail", "wind", "teleporter", "treadmill", "upblower", "boulder", "blackhole", "goal", "sawslide"]

# Блоки, которых нет в инвентаре оригинала: в выборе их не предлагают (зеркало OFFER_EXCLUDED в cloudflare/src/catalog.js).
const OFFER_EXCLUDED := ["goal", "boulder", "wind", "toxic", "flamethrower", "crumble", "sawslide", "pillar"]

const BLOCKS := {
	"plank":  {"name": "Щепка",     "size": Vector2i(3, 1), "kind": "solid",  "color": Color(0.78, 0.59, 0.31)},
	"box":    {"name": "Коробок",   "size": Vector2i(2, 2), "kind": "solid",  "color": Color(0.80, 0.55, 0.33)},
	"pillar": {"name": "Карандаш",  "size": Vector2i(1, 3), "kind": "solid",  "color": Color(0.95, 0.78, 0.25)},
	"spikes": {"name": "Чертополох","size": Vector2i(2, 1), "kind": "hazard", "color": Color(0.60, 0.25, 0.66)},
	"saw":    {"name": "Шестерёнка","size": Vector2i(2, 2), "kind": "sawspin", "color": Color(0.80, 0.45, 0.15)},
	"spring": {"name": "Пружинка",  "size": Vector2i(1, 1), "kind": "spring", "color": Color(0.25, 0.72, 0.68)},
	"mover":  {"name": "Листок",    "size": Vector2i(3, 1), "kind": "mover",  "color": Color(0.52, 0.74, 0.30)},
	"dynamite": {"name": "Динамит", "size": Vector2i(1, 1), "kind": "bomb", "color": Color(0.85, 0.22, 0.18)},
	"bomb":   {"name": "Бомба",     "size": Vector2i(2, 2), "kind": "bomb",   "color": Color(0.20, 0.20, 0.26)},
	"nuke":   {"name": "Ядерная бомба", "size": Vector2i(3, 3), "kind": "bomb", "color": Color(0.93, 0.78, 0.15)},
	"crossbow": {"name": "Арбалет", "size": Vector2i(2, 1), "kind": "shooter", "color": Color(0.55, 0.38, 0.22),
		"first": 1.0, "period": 2.4, "speed": 230.0},
	"flamethrower": {"name": "Огнемёт", "size": Vector2i(1, 1), "kind": "flame", "color": Color(0.45, 0.45, 0.52),
		"range": 3, "on": 1.2, "period": 3.4},
	"coin":   {"name": "Монета",    "size": Vector2i(1, 1), "kind": "coin",   "color": Color(0.98, 0.80, 0.20)},
	"pendulum": {"name": "Маятник", "size": Vector2i(1, 1), "kind": "pendulum", "color": Color(0.55, 0.55, 0.60),
		"arm": 2.5, "swing": 70.0, "freq": 1.8},
	# Блоки из scripts/ported (логика — Placeable и наследники): ice/honey — платформы с особой поверхностью,
	# toxic/sawrail/axe — убивают (очки получает хозяин), wind — дует в сторону поворота.
	"ice":    {"name": "Лёд",       "size": Vector2i(3, 1), "kind": "ice",    "color": Color(0.62, 0.86, 0.96)},
	"honey":  {"name": "Мёд",       "size": Vector2i(3, 1), "kind": "honey",  "color": Color(0.96, 0.69, 0.15)},
	"toxic":  {"name": "Яд",        "size": Vector2i(2, 1), "kind": "toxic",  "color": Color(0.45, 0.85, 0.20)},
	"sawrail": {"name": "Пила на рельсе", "size": Vector2i(4, 1), "kind": "sawrail", "color": Color(0.72, 0.72, 0.78)},
	"teleporter": {"name": "Телепорт", "size": Vector2i(1, 1), "kind": "teleporter", "color": Color(0.62, 0.38, 0.90)},
	"treadmill": {"name": "Дорожка", "size": Vector2i(4, 1), "kind": "treadmill", "color": Color(0.45, 0.45, 0.52)},
	"upblower": {"name": "Вентилятор", "size": Vector2i(1, 1), "kind": "upblower", "color": Color(0.60, 0.80, 0.90)},
	"boulder": {"name": "Валун", "size": Vector2i(2, 2), "kind": "boulder", "color": Color(0.55, 0.53, 0.50)},
	"blackhole": {"name": "Чёрная дыра", "size": Vector2i(3, 3), "kind": "blackhole", "color": Color(0.20, 0.10, 0.35)},
	"crumble": {"name": "Хрупкий блок", "size": Vector2i(3, 1), "kind": "crumble", "color": Color(0.74, 0.56, 0.38)},
	"autodoor": {"name": "Автодверь", "size": Vector2i(1, 3), "kind": "autodoor", "color": Color(0.55, 0.62, 0.72)},
	"punch":  {"name": "Боксёр",    "size": Vector2i(2, 1), "kind": "punch",  "color": Color(0.82, 0.30, 0.30)},
	"hockey": {"name": "Хоккеист", "size": Vector2i(1, 1), "kind": "hockey", "color": Color(0.30, 0.45, 0.75)},
	"cannon": {"name": "Пушка", "size": Vector2i(2, 2), "kind": "cannon", "color": Color(0.38, 0.40, 0.46)},
	"beehive": {"name": "Улей", "size": Vector2i(2, 2), "kind": "beehive", "color": Color(0.90, 0.72, 0.20)},
	"pressure": {"name": "Нажимная плита", "size": Vector2i(2, 1), "kind": "pressure", "color": Color(0.62, 0.62, 0.66)},
	"hydrant": {"name": "Гидрант", "size": Vector2i(1, 1), "kind": "hydrant", "color": Color(0.85, 0.20, 0.20)},
	"flipper": {"name": "Переворотник", "size": Vector2i(2, 1), "kind": "flipper", "color": Color(0.45, 0.62, 0.78)},
	"rotator": {"name": "Вертушка", "size": Vector2i(3, 1), "kind": "rotator", "color": Color(0.70, 0.50, 0.30)},
	"lift":   {"name": "Подъёмник", "size": Vector2i(2, 1), "kind": "lift", "color": Color(0.55, 0.45, 0.35)},
	"plant":  {"name": "Цветок-боец", "size": Vector2i(1, 1), "kind": "plant", "color": Color(0.85, 0.40, 0.70)},
	"goal":   {"name": "Флаг",      "size": Vector2i(1, 2), "kind": "goal",   "color": Color(0.85, 0.20, 0.20)},
	"sawslide": {"name": "Пила-бегунок", "size": Vector2i(3, 1), "kind": "sawslide", "color": Color(0.72, 0.72, 0.78)},
	"wind":   {"name": "Ветер",     "size": Vector2i(3, 3), "kind": "wind",   "color": Color(0.70, 0.88, 0.95)},
}


static func block_ids() -> Array:
	return BLOCKS.keys()


## Размер блока в клетках; rot — число четвертей оборота по часовой стрелке (0..3), при нечётном ширина и высота меняются.
static func size_of(type: String, rot := 0) -> Vector2i:
	var s: Vector2i = BLOCKS[type]["size"]
	return Vector2i(s.y, s.x) if rot % 2 == 1 else s


## Единичный вектор «куда смотрит» блок: 0 — вверх, 1 — вправо, 2 — вниз, 3 — влево.
static func facing_of(rot: int) -> Vector2:
	return [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT][posmod(rot, 4)]


static func static_occupied(map := 0) -> Dictionary:
	var d := {}
	for r in MAPS[map].rects:
		_mark_rect(d, r)
	for r in reserved_rects(map):
		_mark_rect(d, r)
	return d


static func _mark_rect(d: Dictionary, r: Rect2i) -> void:
	for x in range(r.position.x, r.position.x + r.size.x):
		for y in range(r.position.y, r.position.y + r.size.y):
			d[Vector2i(x, y)] = true


static func block_cells(type: String, origin: Vector2i, rot := 0) -> Array:
	var s := size_of(type, rot)
	var cells := []
	for x in range(origin.x, origin.x + s.x):
		for y in range(origin.y, origin.y + s.y):
			cells.append(Vector2i(x, y))
	return cells


static func can_place(type: String, origin: Vector2i, occupied: Dictionary, rot := 0) -> bool:
	if not BLOCKS.has(type) or rot < 0 or rot > 3:
		return false
	var s := size_of(type, rot)
	if origin.x < 0 or origin.y < 0:
		return false
	if origin.x + s.x > GRID_W or origin.y + s.y > GRID_H - 1:
		return false
	for c in block_cells(type, origin, rot):
		if occupied.has(c):
			return false
	return true


static func mark(type: String, origin: Vector2i, occupied: Dictionary, rot := 0) -> void:
	for c in block_cells(type, origin, rot):
		occupied[c] = true


static func setup_input() -> void:
	_add_action("move_left", [KEY_A, KEY_LEFT])
	_add_action("move_right", [KEY_D, KEY_RIGHT])
	_add_action("jump", [KEY_SPACE, KEY_W, KEY_UP])
	_add_action("sprint", [KEY_SHIFT])


static func _add_action(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var e := InputEventKey.new()
		e.physical_keycode = k
		InputMap.action_add_event(action, e)
