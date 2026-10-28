# Каркас из structur/ActiveBlock.cs + логика, написанная вручную (в Il2Cpp-дампе тел методов нет). Конвертер этот файл не трогает.
class_name ActiveBlock
extends Placeable

enum ActMode {
	UPDATE,
	FIXED,
	NEVER,
}
@export var moving_platform: bool
var act_update_mode
var is_active: bool
var paused: bool
var scoreboard: bool
var active: bool  # C# property


func act_on_fixed():  # C# actOnFixed (coroutine)
	pass

func act_on_update():  # C# actOnUpdate (coroutine)
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func act(delta_time: float) -> void:  # C# Act
	pass

func disable_0() -> void:  # C# Disable
	super()
	is_active = false

func activate_0() -> void:  # C# Activate
	is_active = true
	paused = false

func pause_0() -> void:  # C# Pause
	paused = true

func unpause_0() -> void:  # C# Unpause
	paused = false

func to_play_mode() -> void:  # C# ToPlayMode
	super()
	if placed:
		activate_0()

func to_place_mode_1(enable_selection: bool) -> void:  # C# ToPlaceMode
	super(enable_selection)
	is_active = false

func to_sudden_death() -> void:  # C# ToSuddenDeath
	pass

func complete_reset():  # C# CompleteReset (coroutine)
	is_active = false
	paused = false
	position = original_position

func time_to_wait_for_reset_reactivation():  # C# TimeToWaitForResetReactivation
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func _physics_process(delta: float) -> void:
	super(delta)
	if is_active and not paused and is_live():
		act(delta)
