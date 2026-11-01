import re, sys, os
ROOT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "scripts", "ported") + os.sep
HEADER = "# Каркас из structur/{src}.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает."

def find_func(lines, name):
    rx = re.compile(r"^(static )?func %s\(" % re.escape(name))
    for i, l in enumerate(lines):
        if rx.match(l): return i
    return None

def func_end(lines, i):
    j = i + 1
    while j < len(lines) and (lines[j].startswith("\t") or lines[j] == ""): j += 1
    while lines[j - 1] == "": j -= 1
    return j

def patch(rel, funcs=None, defaults=None, remove=(), append="", sets=None):
    path = ROOT + rel
    text = open(path).read()
    lines = text.split("\n")
    src = re.search(r"structur/(\w+)\.cs", lines[0]).group(1) if lines[0].startswith("# Ported") else None
    if src: lines[0] = HEADER.format(src=src)
    for name in remove:
        i = find_func(lines, name)
        if i is None: print("  (nothing to remove)", rel, name); continue
        j = func_end(lines, i); del lines[i:j]
    for name, body in (funcs or {}).items():
        i = find_func(lines, name)
        if i is None: sys.exit(f"{rel}: no func {name}")
        sig = lines[i]
        j = func_end(lines, i)
        new = [sig] + [("\t" + b if b else "") for b in body.strip("\n").split("\n")]
        lines[i:j] = new
    for var, val in (defaults or {}).items():
        rx = re.compile(r"^((?:@export )?(?:static )?var %s)(: \w+)?(\s+#.*)?$" % re.escape(var))
        ok = False
        for i, l in enumerate(lines):
            m = rx.match(l)
            if m:
                lines[i] = f"{m.group(1)}{m.group(2) or ''} = {val}{m.group(3) or ''}"; ok = True; break
        if not ok: sys.exit(f"{rel}: no var {var}")
    out = "\n".join(lines).rstrip() + "\n"
    if append: out += "\n" + append.strip("\n") + "\n"
    open(path, "w").write(out)
    print("patched", rel)

# ------------------------------------------------------------------ Placeable
patch("blocks/placeable.gd",
 defaults={"u_enabled": "true"},
 remove=["_physics_process"],
 funcs={
 "_enter_tree": """
if id == 0:
	id_count += 1
	id = id_count""",
 "_exit_tree": """
for c in zone_characters:
	if is_instance_valid(c):
		on_character_exited(c)
zone_characters.clear()""",
 "disable_0": """
u_disabled = true
u_enabled = false
for c in zone_characters:
	if is_instance_valid(c):
		on_character_exited(c)""",
 "enable_0": """
u_disabled = false
u_enabled = true
for c in zone_characters:
	if is_instance_valid(c):
		on_character_entered(c)""",
 "enable_placed": """
placing = false
u_enabled = true
u_disabled = false""",
 "enable_placement": """
placing = true""",
 "pick_up": """
set_picked_up(true)""",
 "set_picked_up": """
picked_up = value
placed = not value
if value:
	disable_0()
else:
	enable_0()""",
 "place_1": """
place_3(player_number, false, false)""",
 "place_3": """
placed_by_player_number = player_number
placed = true
picked_up = false
original_position = position
enable_placed()""",
 "reset_transform": """
position = original_position""",
 "can_place": """
return not placement_lock and not marked_for_destruction and not picked_up""",
 "can_place_check": """
can_place_cache = can_place()
return can_place_cache""",
 "get_top_piece": """
var p: Placeable = self
while p.parent_piece != null:
	p = p.parent_piece
return p""",
 "flip": """
scale.x = -scale.x""",
 "get_total_mass": """
var m := u_mass
for p in child_pieces:
	if is_instance_valid(p):
		m += p.get_total_mass()
return m""",
 "get_physics_modifiers": """
return []""",
 "get_physics_modifier": """
return get_physics_modifiers()""",
 "attach_piece": """
if p == null or child_pieces.has(p):
	return
child_pieces.append(p)
p.parent_piece = self""",
 "detach_piece": """
child_pieces.erase(p)
if p != null and p.parent_piece == self:
	p.parent_piece = null""",
 "detach_all_children": """
for p in child_pieces:
	if is_instance_valid(p) and p.parent_piece == self:
		p.parent_piece = null
child_pieces.clear()""",
 "destroy_self_in": """
await get_tree().create_timer(time).timeout
if is_instance_valid(self):
	destroy_self_3(destroy_children, use_smoke, false)""",
 "destroy_self_3": """
if marked_for_destruction:
	return
marked_for_destruction = true
if destroy_children:
	for p in child_pieces.duplicate():
		if is_instance_valid(p):
			p.destroy_self_3(true, use_smoke, send_network_signal)
disable_0()
if parent_piece != null:
	parent_piece.detach_piece(self, true)
queue_free()""",
 "to_play_mode": """
placing = false""",
 "to_place_mode_1": """
placing = true""",
 "end_play": """
placing = false""",
 "u_set_color": """
custom_color = new_color
modulate = new_color""",
 "calculate_mass_ratio": """
return mass_influence_ratio""",
 "get_children_and_parts": """
return child_pieces.duplicate()""",
 "set_initial_damage_level": """
damage_level = damage
if allow_damage_reset:
	initial_damage = damage""",
 "add_bomb_damage": """
if not damageable or protected:
	return
damage_level += damage_amount
if damage_level >= destroyed_damage_level and destroyed_damage_level > 0:
	destroy_self_3(true, true, false)""",
 "get_original_sequence_id": """
return id""",
 },
 append='''
# ---- зона: Area2D, которая следит за персонажами рядом с блоком ----
const PLAYER_LAYER := 2
var zone: Area2D
var zone_characters: Array = []
var clock := 0.0


func _physics_process(delta: float) -> void:
	clock += delta


## Блок «живой», если включён, не поднят и не в режиме расстановки.
func is_live() -> bool:
	return u_enabled and not u_disabled and not picked_up and not placing


func setup_zone(size: Vector2, offset := Vector2.ZERO) -> Area2D:
	if zone:
		zone.queue_free()
	zone = Area2D.new()
	zone.collision_layer = 0
	zone.collision_mask = PLAYER_LAYER
	zone.monitorable = false
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape.shape = rect
	shape.position = offset
	zone.add_child(shape)
	zone.body_entered.connect(_zone_body_entered)
	zone.body_exited.connect(_zone_body_exited)
	add_child(zone)
	return zone


func _zone_body_entered(body: Node) -> void:
	if body is Character and not zone_characters.has(body):
		zone_characters.append(body)
		if is_live():
			on_character_entered(body)


func _zone_body_exited(body: Node) -> void:
	if zone_characters.has(body):
		zone_characters.erase(body)
		on_character_exited(body)


## По умолчанию — применяет к персонажу физические модификаторы блока (get_physics_modifiers), пока он в зоне.
func on_character_entered(c: Character) -> void:
	var merged := {}
	for pm: Dictionary in get_physics_modifiers():
		for k in pm:
			merged[k] = merged.get(k, 1.0) * pm[k]
	if not merged.is_empty():
		c.apply_physics_modifier(self, merged)


func on_character_exited(c: Character) -> void:
	c.remove_physics_modifier(self)
''')

# ------------------------------------------------------------------ ActiveBlock
patch("blocks/active_block.gd",
 remove=["on_enable"],
 funcs={
 "act": "pass",
 "disable_0": """
super()
is_active = false""",
 "activate_0": """
is_active = true
paused = false""",
 "pause_0": """
paused = true""",
 "unpause_0": """
paused = false""",
 "to_play_mode": """
super()
if placed:
	activate_0()""",
 "to_place_mode_1": """
super(enable_selection)
is_active = false""",
 "to_sudden_death": "pass",
 "complete_reset": """
is_active = false
paused = false
position = original_position""",
 },
 append='''
func _physics_process(delta: float) -> void:
	super(delta)
	if is_active and not paused and is_live():
		act(delta)
''')

# ------------------------------------------------------------------ Spring
patch("blocks/spring.gd",
 defaults={"strength": "410.0", "direction": "Vector2.UP"},
 funcs={
 "_ready": """
setup_zone(Vector2(16, 8), direction.normalized() * 8.0)""",
 "_physics_process": """
super(delta)
if not is_live():
	return
for c: Character in zone_characters:
	if is_instance_valid(c) and not c.dead and not c.dying and clock - last_pushed.get(c, -INF) >= PUSH_DELAY:
		last_pushed[c] = clock
		c.bounce(strength, direction.normalized())""",
 },
 append='''
func on_character_exited(c: Character) -> void:
	last_pushed.erase(c)
''')

# ------------------------------------------------------------------ Ice / Honey
patch("blocks/ice.gd", defaults={"slickness": "0.9"},
 remove=["_enter_tree", "get_physics_modifier"],
 funcs={"get_physics_modifiers": 'return [{"ground_friction": 1.0 - slickness}]'},
 append='''
func _ready() -> void:
	setup_zone(Vector2(16, 6), Vector2(0, -6))
''')
patch("blocks/honey.gd", defaults={"stickiness": "0.5", "jump_stickiness": "0.3"},
 remove=["_enter_tree", "get_physics_modifier"],
 funcs={"get_physics_modifiers": '''return [{"ground_friction": 1.0 + stickiness * 2.0, "run_speed": 1.0 - stickiness * 0.5, "jump_force": 1.0 - jump_stickiness * 0.5}]'''},
 append='''
func _ready() -> void:
	setup_zone(Vector2(16, 6), Vector2(0, -6))
''')

# ------------------------------------------------------------------ платформы
def platform(rel, horizontal):
    ang = "0.0" if horizontal else "move_angle"
    patch(rel, defaults={"move_speed": "40.0", "max_distance": "96.0"},
      remove=["_enter_tree", "enable_0", "disable_0", "place_3", "pause_0", "unpause_0", "get_physics_modifiers", "get_physics_modifier"] + (["update_move_dir"] if False else []),
      funcs={
       "_ready": """
start_origin = position
last_position = position
setup_zone(platform_size, Vector2(0, -platform_size.y))""",
       "act": f"""
var dir := Vector2.RIGHT.rotated(deg_to_rad({ang}))
amount_moved += move_speed * delta * _sign
if amount_moved >= max_distance:
	amount_moved = max_distance
	_sign = -1.0
elif amount_moved <= 0.0:
	amount_moved = 0.0
	_sign = 1.0
var prev := position
position = start_origin + dir * amount_moved
last_velocity = velocity
velocity = (position - prev) / delta
last_position = position""",
      },
      append='''
var platform_size := Vector2(48, 8)
var start_origin := Vector2.ZERO
var _sign := 1.0


func _physics_process(delta: float) -> void:
	super(delta)
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.character_inherited_motion = velocity


func on_character_entered(_c: Character) -> void:
	pass


func on_character_exited(c: Character) -> void:
	c.character_inherited_motion = Vector2.ZERO
''')
platform("blocks/moving_platform.gd", False)
platform("blocks/horizontal_moving_platform.gd", True)

# ------------------------------------------------------------------ пилы и топор
patch("blocks/linear_saw.gd", defaults={"saw_move_speed": "48.0"},
 remove=["_enter_tree", "disable_0", "enable_0", "enable_placement", "place_1", "activate_0", "pause_0", "unpause_0"],
 funcs={"act": """
if spinner:
	spinner.rotation += 10.0 * delta
amount_moved += saw_move_speed * delta * _sign
if amount_moved >= travel_distance:
	amount_moved = travel_distance
	_sign = -1.0
elif amount_moved <= 0.0:
	amount_moved = 0.0
	_sign = 1.0
position = start_origin + travel_dir.normalized() * amount_moved
for c: Character in zone_characters:
	if is_instance_valid(c):
		c.kill_character(kill_type if kill_type != "" else "saw")"""},
 append='''
var travel_dir := Vector2.RIGHT
var travel_distance := 64.0
var blade_size := Vector2(20, 20)
var start_origin := Vector2.ZERO
var amount_moved := 0.0
var _sign := 1.0


func _ready() -> void:
	start_origin = position
	setup_zone(blade_size)
''')
patch("blocks/swinging_axe.gd", defaults={"saw_move_speed": "2.0"},
 remove=["_enter_tree", "_process", "disable_0", "enable_0", "enable_placement", "place_1", "activate_0", "pause_0", "unpause_0"],
 funcs={"act": """
_t += delta * saw_move_speed
var pivot: Node2D = rotate_locked if rotate_locked else self
pivot.rotation = amplitude * sin(_t)
for c: Character in zone_characters:
	if is_instance_valid(c):
		c.kill_character(kill_type if kill_type != "" else "axe")"""},
 append='''
var amplitude := 1.0           # размах качания, рад
var axe_length := 40.0
var axe_head_size := Vector2(24, 24)
var _t := 0.0


func _ready() -> void:
	var z := setup_zone(axe_head_size, Vector2(0, axe_length))
	if rotate_locked:
		remove_child(z)
		rotate_locked.add_child(z)
''')
patch("hazards/saw_spin.gd", defaults={"spin_speed": "8.0"},
 funcs={"_ready": "pass", "_process": "rotation += spin_speed * delta"})
patch("hazards/saw_spin_and_move.gd", defaults={"spin_speed": "8.0", "move_speed": "40.0", "max_left": "48.0", "max_right": "48.0"},
 funcs={"_ready": """
_origin_x = position.x
if not going_left and not going_right:
	going_right = true""",
 "_process": """
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
		going_right = true"""},
 append="\nvar _origin_x := 0.0\n")

# ------------------------------------------------------------------ яд, цель, монета
patch("blocks/toxic_waste.gd",
 remove=["_enter_tree", "activate_0", "pause_0", "unpause_0"],
 append='''
func _ready() -> void:
	setup_zone(Vector2(32, 16))


func act(_delta: float) -> void:
	for c: Character in zone_characters:
		if is_instance_valid(c):
			c.kill_character(kill_type if kill_type != "" else "toxic")
''')
patch("blocks/goal_block.gd", append='''
func _ready() -> void:
	setup_zone(Vector2(16, 32))


func on_character_entered(c: Character) -> void:
	if not c.dead and not c.dying:
		c.set_success(true)
''')
patch("blocks/coin.gd", defaults={"coin_follow_distance": "14.0", "return_to_holder_time": "1.0"},
 remove=["activate_0", "disable_0", "pause_0", "unpause_0", "place_3", "on_trigger_enter_2d"],
 funcs={
 "_ready": """
start_position = Vector3(global_position.x, global_position.y, 0.0)
at_spawn_point = true
setup_zone(Vector2(14, 14))""",
 "_process": """
if not is_instance_valid(carrier):
	carrier = null
	return
if carrier.dying or carrier.dead:
	drop(carrier.global_position, true)
elif carrier.success:
	do_award_animation()
else:
	var target := carrier.global_position + Vector2(-carrier.facing * coin_follow_distance, -16.0)
	global_position = global_position.lerp(target, clampf(12.0 * delta, 0.0, 1.0))""",
 "drop": """
carrier = null
global_position = coin_position
coin_moving = false
if return_to_respawn or always_respawn or force_always_respawn:
	return_coin_to_spawn()""",
 "do_award_animation": """
if awarded or carrier == null:
	return
awarded = true
carrier.coins_collected += 1
coin_moving = false
visible = false""",
 "pickup": """
carrier = chr
at_spawn_point = false
coin_moving = true
pickup_requester = chr""",
 "return_coin_to_spawn": """
carrier = null
global_position = Vector2(start_position.x, start_position.y)
at_spawn_point = true
coin_moving = false""",
 "set_carrier": """
carrier = chr""",
 },
 append='''
func on_character_entered(c: Character) -> void:
	if carrier == null and not awarded and not c.dead and not c.dying:
		pickup(c)
''')

# ------------------------------------------------------------------ ветер и чёрная дыра
patch("hazards/wind_area.gd",
 defaults={"operation_mode": "OperationMode.Wind", "blow_direction": "Vector2.UP", "character_blow_power": "400.0", "projectile_blow_power": "400.0"},
 funcs={
 "_ready": """
area = Area2D.new()
area.collision_layer = 0
area.collision_mask = 2
area.monitorable = false
var shape := CollisionShape2D.new()
var rect := RectangleShape2D.new()
rect.size = area_size
shape.shape = rect
area.add_child(shape)
area.body_entered.connect(_body_entered)
area.body_exited.connect(_body_exited)
add_child(area)""",
 "_exit_tree": """
for c: Character in affected_characters:
	if is_instance_valid(c):
		c.wind_x = 0.0
		c.wind_y = 0.0
affected_characters.clear()""",
 "_physics_process": """
if pause_wind:
	return
for c: Character in affected_characters:
	if not is_instance_valid(c) or c.dead:
		continue
	if operation_mode == OperationMode.Blackhole:
		var center := blackhole_center.global_position if blackhole_center else global_position
		var to_center := center - c.global_position
		var dist := to_center.length()
		var radius := maxf(area_size.x, area_size.y) * 0.5
		var atten := clampf(1.0 - dist / radius, 0.0, 1.0)
		if black_hole_distance_attenuation:
			atten = black_hole_distance_attenuation.sample(atten)
		var pull := to_center.normalized() * character_blow_power * atten
		c.wind_x = pull.x
		c.wind_y = pull.y
		if dist < kill_radius:
			c.kill_character("blackhole")
	else:
		var push := blow_direction.normalized() * character_blow_power
		c.wind_x = push.x
		c.wind_y = push.y"""},
 append='''
var area: Area2D
var area_size := Vector2(64, 64)
var kill_radius := 6.0


func _body_entered(body: Node) -> void:
	if body is Character and not affected_characters.has(body):
		affected_characters.append(body)


func _body_exited(body: Node) -> void:
	if body is Character:
		affected_characters.erase(body)
		body.wind_x = 0.0
		body.wind_y = 0.0
''')
