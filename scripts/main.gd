extends Control
## Точка входа клиента: меню (выбор скина, адрес сервера, создание комнаты, вход по коду) и лобби.
## Сервер — Cloudflare Worker (см. cloudflare/); в веб-версии адрес берётся с той же страницы.

const SETTINGS_PATH := "user://settings.cfg"
const CONNECT_TIMEOUT := 10.0
const GameScript := preload("res://scripts/game.gd")

var game: Node2D = null
var connect_timer: Timer
var web_base_url := ""

var bg_rect: ColorRect
var menu_root: CenterContainer
var menu_box: VBoxContainer
var room_box: VBoxContainer
var skin := 0                        # выбранный скин = индекс насекомого
var skin_buttons: Array = []
var skin_note: Label
var url_edit: LineEdit
var code_edit: LineEdit
var status: Label
var room_code_label: Label
var players_label: Label
var start_btn: Button
var rules_box: VBoxContainer
var rules_scroll: ScrollContainer
var rules_label: Label                 # правила текстом (видят все; хозяин ещё и меняет их ниже)
var rule_options: Dictionary = {}      # ключ правила -> OptionButton (только у хозяина)
var _rules_syncing := false

# Правила комнаты по категориям (как в меню UCH): ключ, название, варианты [значение, подпись].
const RULE_MENU := [
	["Режим", [
		["map", "Карта", []],   # варианты берутся из Catalog.MAPS
		["mode", "Расстановка", [["party", "Все сразу (Party)"], ["classic", "По очереди (Classic)"]]],
	]],
	["Физика", [
		["gravity", "Гравитация", [["normal", "Обычная"], ["low", "Низкая"]]],
		["sprint", "Бег", [[true, "Есть"], [false, "Нет"]]],
	]],
	["Странности", [
		["death", "После смерти", [["out", "Выбывает"], ["ghost", "Призрак"], ["corpse", "Труп (прыжок на клетку)"]]],
	]],
	["Эффекты блоков", [
		["offer", "Блоков на выбор", [[4, "4"], [5, "5"], [6, "6"]]],
	]],
	["Эффекты уровня", [
		["target", "Играем до очков", [[30, "30"], [20, "20"], [50, "50"]]],
		["accumulate", "Блоки между раундами", [[true, "Остаются"], [false, "Убираются"]]],
	]],
]
var wait_label: Label


func _ready() -> void:
	# Корневой Control по умолчанию «съедает» мышь и касания, и расстановка блока (_unhandled_input
	# в game.gd) их никогда не получала. Кнопки и поля меню от этого не страдают.
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_menu()
	Net.connection_failed.connect(func(): _fail("Не удалось подключиться к серверу"))
	Net.server_lost.connect(_on_server_lost)
	Net.room_error.connect(_on_room_error)
	Net.skins_taken.connect(_apply_taken)
	Net.room_joined.connect(_on_room_joined)
	Net.lobby_updated.connect(_on_lobby_updated)
	Net.phase_changed.connect(_on_phase)
	if code_edit.text.length() == 4:   # код подставлен ссылкой ?code=… — сразу скрываем занятые скины
		_on_code_changed(code_edit.text)


# ======================================================================
#  Интерфейс меню
# ======================================================================

func _build_menu() -> void:
	var th := Theme.new()
	th.default_font_size = 26
	theme = th

	bg_rect = ColorRect.new()
	bg_rect.color = Color(0.30, 0.25, 0.36)
	bg_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg_rect)

	menu_root = CenterContainer.new()
	menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(menu_root)

	var root := VBoxContainer.new()
	root.custom_minimum_size = Vector2(620, 0)
	root.add_theme_constant_override("separation", 12)
	menu_root.add_child(root)

	var title := Label.new()
	title.text = "Gone Done"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	root.add_child(title)

	if _needs_home_screen_hint():
		var hint := Label.new()
		hint.text = "Чтобы убрать панель браузера: Safari → «Поделиться» → «На экран Домой», затем запускайте игру с иконки."
		hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint.add_theme_font_size_override("font_size", 18)
		hint.add_theme_color_override("font_color", Color(0.85, 0.8, 0.95))
		root.add_child(hint)

	var cfg := _load_settings()

	menu_box = VBoxContainer.new()
	menu_box.add_theme_constant_override("separation", 12)
	root.add_child(menu_box)

	skin = clampi(int(cfg.get_value("player", "skin", 0)), 0, Catalog.INSECT_NAMES.size() - 1)
	_build_skin_picker()

	url_edit = LineEdit.new()
	url_edit.placeholder_text = "Адрес сервера, например wss://gone-done.имя.workers.dev"
	url_edit.text = cfg.get_value("player", "url", "")
	if OS.has_feature("web"):
		# В браузере игра открыта с самого сервера, поэтому адрес берём со страницы.
		web_base_url = str(JavaScriptBridge.eval("window.location.origin"))
		var srv := _query_param(str(JavaScriptBridge.eval("window.location.search")), "server")
		if srv != "":
			web_base_url = srv
		url_edit.hide()
	menu_box.add_child(url_edit)

	var create_btn := Button.new()
	create_btn.text = "Создать комнату"
	create_btn.custom_minimum_size = Vector2(0, 70)
	create_btn.pressed.connect(_on_create_pressed)
	menu_box.add_child(create_btn)

	var join_row := HBoxContainer.new()
	join_row.add_theme_constant_override("separation", 12)
	menu_box.add_child(join_row)

	code_edit = LineEdit.new()
	code_edit.placeholder_text = "Код комнаты"
	code_edit.max_length = 4
	if OS.has_feature("web"):
		# Ссылка вида ...?code=AB12 подставляет код сама — удобно, если клавиатура телефона не появляется.
		code_edit.text = _query_param(str(JavaScriptBridge.eval("window.location.search")), "code").to_upper()
	code_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	code_edit.text_changed.connect(_on_code_changed)
	join_row.add_child(code_edit)

	var join_btn := Button.new()
	join_btn.text = "Войти"
	join_btn.custom_minimum_size = Vector2(160, 70)
	join_btn.pressed.connect(_on_join_pressed)
	join_row.add_child(join_btn)

	room_box = VBoxContainer.new()
	room_box.add_theme_constant_override("separation", 12)
	room_box.hide()
	root.add_child(room_box)

	room_code_label = Label.new()
	room_code_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_code_label.add_theme_font_size_override("font_size", 40)
	room_box.add_child(room_code_label)

	players_label = Label.new()
	players_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_box.add_child(players_label)

	rules_scroll = ScrollContainer.new()    # правил много — на низком экране телефона прокручиваются
	rules_scroll.custom_minimum_size = Vector2(0, 250)
	rules_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	room_box.add_child(rules_scroll)
	rules_box = VBoxContainer.new()
	rules_box.add_theme_constant_override("separation", 6)
	rules_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rules_scroll.add_child(rules_box)
	rules_label = Label.new()
	rules_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	rules_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rules_box.add_child(rules_label)
	for cat in RULE_MENU:
		var head := Label.new()
		head.text = cat[0]
		head.add_theme_color_override("font_color", Color(1.0, 0.8, 0.4))
		rules_box.add_child(head)
		for r in cat[1]:
			var row := HBoxContainer.new()
			var name_label := Label.new()
			name_label.text = r[1]
			name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(name_label)
			var opt := OptionButton.new()
			opt.custom_minimum_size = Vector2(240, 44)
			var values := _rule_values(r)
			for v in values:
				opt.add_item(v[1])
			opt.item_selected.connect(_on_rule_selected.bind(r[0], values))
			row.add_child(opt)
			rules_box.add_child(row)
			rule_options[r[0]] = opt

	start_btn = Button.new()
	start_btn.text = "Начать игру"
	start_btn.custom_minimum_size = Vector2(0, 70)
	start_btn.pressed.connect(func(): Net.start_game())
	room_box.add_child(start_btn)

	wait_label = Label.new()
	wait_label.text = "Ждём, пока хозяин комнаты начнёт игру…"
	wait_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_box.add_child(wait_label)

	var leave_btn := Button.new()
	leave_btn.text = "Выйти из комнаты"
	leave_btn.pressed.connect(_leave)
	room_box.add_child(leave_btn)

	status = Label.new()
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_color_override("font_color", Color(1.0, 0.8, 0.4))
	root.add_child(status)

	connect_timer = Timer.new()
	connect_timer.one_shot = true
	connect_timer.timeout.connect(func(): _fail("Сервер не отвечает. Проверьте адрес и интернет."))
	add_child(connect_timer)


## iPhone/iPad в обычной вкладке Safari: интерфейс браузера прячется только при запуске с иконки «Домой».
func _needs_home_screen_hint() -> bool:
	if not OS.has_feature("web"):
		return false
	return bool(JavaScriptBridge.eval("""
		(/iPhone|iPad|iPod/.test(navigator.userAgent) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1))
		&& !(window.navigator.standalone === true
			|| window.matchMedia('(display-mode: standalone)').matches
			|| window.matchMedia('(display-mode: fullscreen)').matches)
	"""))


func _build_skin_picker() -> void:
	var title := Label.new()
	title.text = "Выберите насекомое"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_box.add_child(title)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 4)
	menu_box.add_child(row)

	var group := ButtonGroup.new()
	for i in Catalog.INSECT_NAMES.size():
		var b := Button.new()
		b.toggle_mode = true
		b.button_group = group
		b.button_pressed = i == skin
		b.custom_minimum_size = Vector2(84, 128)
		b.pressed.connect(_select_skin.bind(i))
		var chosen := StyleBoxFlat.new()   # выбранный скин: светлая подложка и золотая рамка
		chosen.bg_color = Color(0.40, 0.34, 0.50)
		chosen.set_border_width_all(4)
		chosen.border_color = Color(1.0, 0.82, 0.35)
		chosen.set_corner_radius_all(6)
		b.add_theme_stylebox_override("pressed", chosen)
		b.add_theme_stylebox_override("hover_pressed", chosen)
		var preview := Art.make_insect(i, Catalog.PLAYER_COLORS[i])   # то же рисование, что и в игре
		preview.position = Vector2(42, 58)
		preview.scale = Vector2(1.25, 1.25)
		b.add_child(preview)
		var caption := Label.new()
		caption.text = Catalog.INSECT_NAMES[i]
		caption.position = Vector2(0, 100)
		caption.size = Vector2(84, 24)
		caption.add_theme_font_size_override("font_size", 14)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(caption)
		row.add_child(b)
		skin_buttons.append(b)

	skin_note = Label.new()
	skin_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	skin_note.add_theme_font_size_override("font_size", 20)
	menu_box.add_child(skin_note)


func _select_skin(i: int) -> void:
	skin = i
	skin_buttons[i].set_pressed_no_signal(true)
	_save_settings()


## Занятые в комнате скины убираем из выбора; если выбранный занят, переходим на первый свободный.
func _apply_taken(taken: Array) -> void:
	var names := []
	for i in skin_buttons.size():
		skin_buttons[i].visible = not taken.has(i)
		if taken.has(i):
			names.append(Catalog.INSECT_NAMES[i])
	skin_note.text = "" if names.is_empty() else "Уже заняты: %s" % ", ".join(names)
	if taken.has(skin):
		for i in skin_buttons.size():
			if not taken.has(i):
				_select_skin(i)
				break


func _on_code_changed(text: String) -> void:
	var code := text.strip_edges().to_upper()
	if code.length() == 4 and _base_url() != "":
		Net.peek_room(_base_url(), code)
	else:
		_apply_taken([])


func _query_param(qs: String, key: String) -> String:
	if qs.begins_with("?"):
		qs = qs.substr(1)
	for pair in qs.split("&"):
		var kv := pair.split("=", true, 1)
		if kv.size() == 2 and kv[0] == key:
			return kv[1].uri_decode()
	return ""


func _load_settings() -> ConfigFile:
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH)
	return cfg


func _save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("player", "skin", skin)
	cfg.set_value("player", "url", url_edit.text.strip_edges())
	cfg.save(SETTINGS_PATH)


# ======================================================================
#  Подключение и комнаты
# ======================================================================

func _base_url() -> String:
	return web_base_url if OS.has_feature("web") else url_edit.text.strip_edges()


func _begin_connect(ok: bool) -> void:
	if ok:
		status.text = "Подключаемся…"
		connect_timer.start(CONNECT_TIMEOUT)
	else:
		_fail("Некорректный адрес сервера")


func _on_create_pressed() -> void:
	if _base_url() == "":
		status.text = "Укажите адрес сервера"
		return
	_save_settings()
	_begin_connect(Net.create_room(_base_url(), skin))


func _on_join_pressed() -> void:
	var code := code_edit.text.strip_edges().to_upper()
	if code.length() != 4:
		status.text = "Код комнаты — 4 символа"
		return
	if _base_url() == "":
		status.text = "Укажите адрес сервера"
		return
	_save_settings()
	_begin_connect(Net.join_room(_base_url(), code, skin))


func _fail(msg: String) -> void:
	connect_timer.stop()
	Net.leave()
	status.text = msg


func _on_room_error(msg: String) -> void:
	connect_timer.stop()
	status.text = msg
	if msg.contains("занят"):
		status.text += "\nСвободный скин уже выбран — нажмите «Войти» ещё раз."


func _on_room_joined(_code: String) -> void:
	connect_timer.stop()
	status.text = ""
	menu_box.hide()
	room_box.show()
	_refresh_room()


func _on_lobby_updated(_host: int, _players: Array) -> void:
	_refresh_room()


## Варианты правила: для карты — все карты каталога, для остальных — как записано в RULE_MENU.
func _rule_values(r: Array) -> Array:
	if r[0] != "map":
		return r[2]
	var out := []
	for i in Catalog.MAPS.size():
		out.append([i, Catalog.MAPS[i].name])
	return out


func _on_rule_selected(index: int, key: String, values: Array) -> void:
	if not _rules_syncing:
		Net.set_rule(key, values[index][0])


## Подпись правила для текущего значения (для игроков без прав хозяина).
func _rule_text(key: String) -> String:
	for cat in RULE_MENU:
		for r in cat[1]:
			if r[0] == key:
				for v in _rule_values(r):
					if v[0] == Net.rules[key]:
						return "%s: %s" % [r[1], v[1]]
	return ""


func _refresh_rules(is_host: bool) -> void:
	_rules_syncing = true
	for cat in RULE_MENU:
		for r in cat[1]:
			var opt: OptionButton = rule_options[r[0]]
			var values := _rule_values(r)
			for i in values.size():
				if values[i][0] == Net.rules[r[0]]:
					opt.select(i)
			opt.get_parent().visible = is_host
	_rules_syncing = false
	var parts := []
	for key in rule_options:
		parts.append(_rule_text(key))
	rules_label.text = "" if is_host else "Правила комнаты\n" + "\n".join(parts)
	rules_label.visible = not is_host
	# заголовки категорий нужны только хозяину, у остальных одна сводка
	for c in rules_box.get_children():
		if c is Label and c != rules_label:
			c.visible = is_host


func _refresh_room() -> void:
	room_code_label.text = "Код комнаты: %s" % Net.room_code
	var lines := []
	for p in Net.players:
		var line: String = str(p.name)
		if p.id == Net.my_id:
			line += "  (вы)"
		if p.id == Net.host_id:
			line += "  (хозяин)"
		lines.append(line)
	players_label.text = "Игроки (%d/%d):\n%s" % [Net.players.size(), Net.MAX_PLAYERS, "\n".join(lines)]
	var is_host := Net.my_id == Net.host_id
	start_btn.visible = is_host
	_refresh_rules(is_host)
	wait_label.visible = not is_host


func _on_phase(phase: int, data: Dictionary) -> void:
	if phase == Catalog.Phase.LOBBY:
		_free_game()
		room_box.show()
		_refresh_room()
		return
	if game == null and phase == Catalog.Phase.PICK:
		game = GameScript.new()
		add_child(game)
		game.leave_requested.connect(_leave)
		menu_box.hide()
		room_box.hide()
		menu_root.hide()
		bg_rect.hide()
	if game != null:
		game.on_phase(phase, data)


func _free_game() -> void:
	if game != null:
		game.queue_free()
		game = null
		bg_rect.show()
		menu_root.show()


func _leave() -> void:
	Net.leave()
	_free_game()
	room_box.hide()
	menu_box.show()
	status.text = ""
	_on_code_changed(code_edit.text)


func _on_server_lost() -> void:
	_free_game()
	room_box.hide()
	menu_box.show()
	status.text = "Связь с сервером потеряна"
