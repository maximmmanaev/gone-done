## Написано вручную по полям и сигнатурам Character.cs из Il2Cpp-дампа (тел методов в дампе нет).
## Сетевой слой Unity (Cmd*/Rpc*/SyncVar) не переносился: в Godot он живёт в Net.
## Числа движения взяты из scripts/player.gd, чтобы персонаж ощущался так же.
class_name Character
extends CharacterBody2D

signal died(cause: String)
signal succeeded
signal jumped
signal landed(fall_speed: float)
signal anim_state_changed(state: int)

enum AnimState {
	IDLE = 0,
	RUN = 1,
	WALK = 2,
	SIT = 3,
	JUMP = 4,
	LAND = 5,
	SLIDE = 6,
	DIE = 7,
	WIN = 8,
}

enum SecondaryAnimState {
	NONE,
	LOOKUP,
	CROUCH,
	DEADFALL,
}

enum Animals {
	NONE,
	CHICKEN,
	HORSE,
	SHEEP,
	RACCOON,
	CHAMELEON,
	SQUIRREL,
	ROBOT,
	ELEPHANT,
	MONKEY,
	SNAKE,
	HIPPO,
	TURTLE,
	PANDA,
}

static var all_characters: Array = []

# --- движение ---
@export var run_speed := 115.0
@export var run_accel := 950.0
@export var ground_friction_force := 1200.0
@export var air_inertia := 175.0              # торможение в воздухе, когда скорость выше предельной
@export var sprint_multiplier := 1.55
@export var velocity_peak := 260.0            # начальная скорость прыжка
@export var gravity := 700.0
@export var lo_gravity_mod := 0.6
@export var fall_terminal_velocity := 450.0
@export var slide_terminal_velocity := 55.0   # скольжение по стене
@export var jump_grace_time := 0.1            # «койот-тайм»
@export var pre_jump_grace_time := 0.12       # буфер нажатия прыжка
@export var wall_stick_time := 0.12
@export var jump_cut := 0.5                   # доля скорости, остающаяся при отпускании прыжка
@export var crouch_speed_mod := 0.5
@export var side_bounce_lift := 130.0
@export var boost_v_max := Vector2(1.4, 1.2)  # множители скорости и прыжка при boost_effect

# --- смерть и финиш ---
@export var min_death_delay := 0.4
@export var deathforce := 220.0
@export var suicide_time := 0.8               # сколько держать кнопку, чтобы покончить с собой
@export var lo_gravity := false
@export var active := false
var jump_scale := 1.0                         # множитель прыжка (правило «труп»)
var gravity_scale := 1.0                      # множитель гравитации (правило «низкая гравитация»)

# --- ввод (заполняется feed_input или read_local_input) ---
var left_input := 0.0
var right_input := 0.0
var up := 0.0
var down := 0.0
var jump := false
var jump_down := false
var jump_up := false
var sprint := false
var suicide := false
var suicide_down := false

# --- состояние ---
var on_ground := false
var just_landed := false
var on_wall := false
var jumping := false
var sprinting := false
var crouching_down := false
var sitting := false
var walking := false
var dying := false
var dead := false
var success := false
var frozen := false
var is_ghost := false                         # призрак: блоки на него не действуют
var paused := false
var temp_lock_input := false
var facing := 1
var wall_jump_direction := 0
var last_fall_speed := 0.0
var last_death := ""
var last_killer: Node = null                  # блок, убивший персонажа (для очков хозяину ловушки)
var coins_collected := 0

var current_anim := AnimState.IDLE
var secondary_anim := SecondaryAnimState.NONE

# --- модификаторы (лёд, мёд, ветер, чёрная дыра, движущиеся платформы) ---
var physics_modifiers: Dictionary = {}        # ключ -> {ground_friction, gravity, jump_force, air_inertia, run_speed}
var ground_friction_modifier := 1.0
var gravity_modifier := 1.0
var jump_force_modifier := 1.0
var air_inertia_modifier := 1.0
var run_speed_modifier := 1.0
var wind_x := 0.0
var wind_y := 0.0
var character_inherited_motion := Vector2.ZERO

# --- таймеры ---
var jump_grace_timer := 0.0
var pre_jump_grace_timer := 0.0
var wall_stick_timer := 0.0
var invincible_timer := 0.0
var boost_effect_timer := 0.0
var force_crouch_timer := 0.0
var suicide_timer := 0.0
var idle_timer := 0.0
var death_timer := 0.0
var input_lock_timer := 0.0
var force_allow_suicide_timer := 0.0

var pause_vel := Vector2.ZERO
var spawn_position := Vector2.ZERO
var _last_anim := -1


func _enter_tree() -> void:
	all_characters.append(self)


func _exit_tree() -> void:
	all_characters.erase(self)


func _ready() -> void:
	spawn_position = position


# ---------- ввод ----------

func reset_input() -> void:
	left_input = 0.0
	right_input = 0.0
	up = 0.0
	down = 0.0
	jump = false
	jump_down = false
	jump_up = false
	sprint = false
	suicide = false
	suicide_down = false


## Для тестов и удалённых игроков: dir от -1 до 1, jump_held — кнопка прыжка зажата.
func feed_input(dir: float, jump_held: bool, sprint_held := false, down_held := false) -> void:
	var was_held := jump
	left_input = maxf(-dir, 0.0)
	right_input = maxf(dir, 0.0)
	jump = jump_held
	jump_down = jump_held and not was_held
	jump_up = was_held and not jump_held
	sprint = sprint_held
	down = 1.0 if down_held else 0.0


## Ввод локального игрока из карты действий проекта (move_left/move_right/jump/sprint).
func read_local_input() -> void:
	var was_held := jump
	left_input = Input.get_action_strength("move_left")
	right_input = Input.get_action_strength("move_right")
	jump = Input.is_action_pressed("jump")
	jump_down = jump and not was_held
	jump_up = was_held and not jump
	sprint = Input.is_action_pressed("sprint")


func lock_input_temporarily(duration: float) -> void:
	input_lock_timer = duration
	temp_lock_input = true


func _axis() -> float:
	if temp_lock_input or dying or dead or success or frozen or paused:
		return 0.0
	return right_input - left_input


# ---------- физика ----------

func _physics_process(delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		return
	step(delta)


## Один физический шаг. Отдельно от _physics_process, чтобы тесты могли шагать вручную.
func step(delta: float) -> void:
	_tick_timers(delta)
	if frozen or paused:
		velocity = Vector2.ZERO
		return

	var was_on_ground := on_ground
	var dir := _axis()
	var locked := temp_lock_input or dying or dead or success
	crouching_down = not locked and (down > 0.5 or force_crouch_timer > 0.0) and on_ground
	sprinting = not locked and sprint and not crouching_down
	var top := run_speed * run_speed_modifier
	if sprinting:
		top *= sprint_multiplier
	if crouching_down:
		top *= crouch_speed_mod
	if boost_effect_timer > 0.0:
		top *= boost_v_max.x

	# горизонталь
	if dir != 0.0:
		facing = 1 if dir > 0.0 else -1
		var accel := run_accel * (sprint_multiplier if sprinting else 1.0)
		if absf(velocity.x) > top and signf(velocity.x) == signf(dir):
			var brake := run_accel if on_ground else air_inertia * air_inertia_modifier
			velocity.x = move_toward(velocity.x, dir * top, brake * delta)
		else:
			velocity.x = move_toward(velocity.x, dir * top, accel * delta)
	else:
		var fr := ground_friction_force * (ground_friction_modifier if on_ground else 1.0)
		velocity.x = move_toward(velocity.x, 0.0, fr * delta)

	# гравитация
	var g := gravity * gravity_scale * gravity_modifier * (lo_gravity_mod if lo_gravity else 1.0)
	velocity.y = minf(velocity.y + g * delta, fall_terminal_velocity)
	velocity.x += wind_x * delta
	velocity.y += wind_y * delta

	# стена
	on_wall = is_on_wall_only()
	if on_wall:
		wall_stick_timer = wall_stick_time
		wall_jump_direction = int(get_wall_normal().x)
		if dir != 0.0 and velocity.y > slide_terminal_velocity and signf(dir) == -signf(get_wall_normal().x):
			velocity.y = slide_terminal_velocity

	# прыжок
	jump_grace_timer = jump_grace_time if on_ground else jump_grace_timer - delta
	pre_jump_grace_timer = pre_jump_grace_time if (jump_down and not locked) else pre_jump_grace_timer - delta
	if pre_jump_grace_timer > 0.0 and not locked:
		if jump_grace_timer > 0.0:
			_do_jump(0)
		elif on_wall or wall_stick_timer > 0.0 and not on_ground:
			_do_jump(wall_jump_direction, top)
	if jump_up and velocity.y < -100.0:
		velocity.y *= jump_cut

	# движение с учётом платформы под ногами
	velocity += character_inherited_motion
	move_and_slide()
	velocity -= character_inherited_motion

	on_ground = is_on_floor()
	just_landed = on_ground and not was_on_ground
	if not on_ground:
		last_fall_speed = maxf(last_fall_speed, velocity.y)
	if just_landed:
		jumping = false
		landed.emit(last_fall_speed)
		last_fall_speed = 0.0
	elif on_ground:
		last_fall_speed = 0.0

	walking = on_ground and absf(velocity.x) > 5.0
	idle_timer = 0.0 if (walking or not on_ground or dir != 0.0) else idle_timer + delta
	sitting = on_ground and crouching_down and dir == 0.0
	_update_suicide(delta)
	_update_anim()


func _do_jump(wall_dir: int, top := 0.0) -> void:
	var power := velocity_peak * jump_scale * jump_force_modifier
	if boost_effect_timer > 0.0:
		power *= boost_v_max.y
	velocity.y = -power
	if wall_dir != 0:
		velocity.x = wall_dir * (top if top > 0.0 else run_speed)
		facing = wall_dir
	pre_jump_grace_timer = 0.0
	jump_grace_timer = 0.0
	wall_stick_timer = 0.0
	on_ground = false
	jumping = true
	jumped.emit()


func _tick_timers(delta: float) -> void:
	invincible_timer = maxf(invincible_timer - delta, 0.0)
	boost_effect_timer = maxf(boost_effect_timer - delta, 0.0)
	force_crouch_timer = maxf(force_crouch_timer - delta, 0.0)
	force_allow_suicide_timer = maxf(force_allow_suicide_timer - delta, 0.0)
	wall_stick_timer = maxf(wall_stick_timer - delta, 0.0)
	if input_lock_timer > 0.0:
		input_lock_timer -= delta
		if input_lock_timer <= 0.0:
			temp_lock_input = false
	if dying:
		death_timer += delta
		if death_timer >= min_death_delay:
			dying = false
			dead = true


func _update_suicide(delta: float) -> void:
	if dead or dying or success or temp_lock_input:
		suicide_timer = 0.0
		return
	if suicide:
		suicide_timer += delta
		if suicide_timer >= suicide_time:
			suicide_timer = 0.0
			kill_character("suicide")
	else:
		suicide_timer = 0.0


# ---------- анимация ----------

func _update_anim() -> void:
	var s := AnimState.IDLE
	if dead or dying:
		s = AnimState.DIE
	elif success:
		s = AnimState.WIN
	elif sitting:
		s = AnimState.SIT
	elif not on_ground:
		s = AnimState.SLIDE if (on_wall and velocity.y > 0.0) else AnimState.JUMP
	elif just_landed:
		s = AnimState.LAND
	elif absf(velocity.x) > run_speed * 0.8:
		s = AnimState.RUN
	elif walking:
		s = AnimState.WALK
	current_anim = s
	secondary_anim = SecondaryAnimState.CROUCH if crouching_down else (SecondaryAnimState.DEADFALL if dying else (SecondaryAnimState.LOOKUP if up > 0.5 else SecondaryAnimState.NONE))
	if _last_anim != s:
		_last_anim = s
		anim_state_changed.emit(s)


# ---------- жизнь, смерть, финиш ----------

func kill_character(cause: String, source: Node = null) -> void:
	if dead or dying or success or is_ghost or invincible_timer > 0.0:
		return
	last_death = cause
	last_killer = source
	dying = true
	death_timer = 0.0
	velocity = Vector2(-facing * deathforce * 0.3, -deathforce)
	died.emit(cause)


func force_death_velocity(vel: Vector2) -> void:
	velocity = vel


func on_hit_level_bottom() -> void:
	kill_character("pit")


func set_success(value: bool) -> void:
	if value and (dead or dying) or success == value:
		return
	success = value
	if value:
		velocity.x = 0.0
		succeeded.emit()


func remove_success() -> void:
	success = false


func respawn() -> void:
	dying = false
	dead = false
	success = false
	frozen = false
	paused = false
	death_timer = 0.0
	last_death = ""
	reset_input()
	reset_variables()
	position = spawn_position


func reset_variables() -> void:
	velocity = Vector2.ZERO
	on_ground = false
	on_wall = false
	jumping = false
	crouching_down = false
	sitting = false
	jump_grace_timer = 0.0
	pre_jump_grace_timer = 0.0
	wall_stick_timer = 0.0
	suicide_timer = 0.0
	idle_timer = 0.0
	last_fall_speed = 0.0
	invincible_timer = 0.0
	boost_effect_timer = 0.0
	force_crouch_timer = 0.0
	input_lock_timer = 0.0
	temp_lock_input = false
	remove_all_physics_modifers()
	wind_x = 0.0
	wind_y = 0.0
	character_inherited_motion = Vector2.ZERO


func position_character(pos: Vector2) -> void:
	position = pos
	velocity = Vector2.ZERO


func start_invincible_timer(time: float) -> void:
	invincible_timer = time


func force_allow_suicide_for(time: float) -> void:
	force_allow_suicide_timer = time


func update_suicidal_state() -> void:
	if force_allow_suicide_timer > 0.0 and suicide_down:
		kill_character("suicide")


# ---------- внешние воздействия ----------

func add_impulse(force: Vector2) -> void:
	velocity += force


## Пружина: как Player.bounce. dir — единичный вектор.
func bounce(speed: float, dir := Vector2.UP) -> void:
	if dir.x != 0.0:
		velocity.x = dir.x * speed
		velocity.y = minf(velocity.y, -side_bounce_lift)
	else:
		velocity.y = dir.y * speed
	jump_grace_timer = 0.0


func force_jump() -> void:
	_do_jump(0)


func fall(vy: float) -> void:
	velocity.y = vy
	on_ground = false


func clear_velocity() -> void:
	velocity = Vector2.ZERO


func force_crouch_command() -> void:
	force_crouch_timer = 0.2


func enable_boost_effect(time: float) -> void:
	boost_effect_timer = time


func freeze(hide_body := false) -> void:
	frozen = true
	visible = not hide_body


func unfreeze() -> void:
	frozen = false
	visible = true


func pause(soft := false) -> void:
	if paused:
		return
	pause_vel = velocity
	paused = true


func unpause(_soft := false) -> void:
	if not paused:
		return
	paused = false
	velocity = pause_vel


func sit_down() -> void:
	sitting = true
	velocity.x = 0.0


func get_boost_lateral_speed_limit(normal_max_speed: float) -> float:
	return normal_max_speed * boost_v_max.x if boost_effect_timer > 0.0 else normal_max_speed


# ---------- физические модификаторы ----------

## pm — Dictionary с любыми ключами: ground_friction, gravity, jump_force, air_inertia, run_speed (множители).
func apply_physics_modifier(key: Variant, pm: Dictionary) -> void:
	physics_modifiers[key] = pm
	_recompute_modifiers()


func remove_physics_modifier(key: Variant) -> void:
	physics_modifiers.erase(key)
	_recompute_modifiers()


func remove_all_physics_modifers() -> void:
	physics_modifiers.clear()
	_recompute_modifiers()


func reproduce_physics_modifiers(other: Character) -> void:
	physics_modifiers = other.physics_modifiers.duplicate(true)
	_recompute_modifiers()


func _recompute_modifiers() -> void:
	ground_friction_modifier = 1.0
	gravity_modifier = 1.0
	jump_force_modifier = 1.0
	air_inertia_modifier = 1.0
	run_speed_modifier = 1.0
	for pm: Dictionary in physics_modifiers.values():
		ground_friction_modifier *= pm.get("ground_friction", 1.0)
		gravity_modifier *= pm.get("gravity", 1.0)
		jump_force_modifier *= pm.get("jump_force", 1.0)
		air_inertia_modifier *= pm.get("air_inertia", 1.0)
		run_speed_modifier *= pm.get("run_speed", 1.0)
