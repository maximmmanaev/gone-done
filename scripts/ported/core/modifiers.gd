# Ported from structur/Modifiers.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Modifiers
extends Resource

enum PostDeathBehaviors {
	None,
	Agony,
	Ghost,
	Zombie,
}

enum CameraFlipModes {
	None,
	FlipX,
	FlipY,
	FlipXY,
}

class PerLevelLavaSettings extends RefCounted:
	var level
	var lava_direction
	var extra_padding: Vector2
	var speed_multiplier: float

enum InvisibilityModes {
	Off,
	WhenMoving,
	WhenStationary,
	Always,
}
static var instance: Modifiers
var mods_applied: bool
var mods_preview: bool
var mods_always_on_debug: bool
var force_lobby_modifiers: bool
var gravity_values: Array
var jump_speed_values: Array
var default_sprint_extra_speed: float
var sprint_modifiers: Array
var game_speed_values: Array
var platform_move_speed_values: Array
var rotator_speed_values: Array
var rate_of_fire_values: Array
var rate_of_fire_audio_event_strings: Array
var projectile_speed_values: Array
var multi_jump_values: Array
var projectile_explosion_scales: Array
var character_scales: Array
var character_size_speed_scales: Array
var character_size_zoom_multipliers: Array
var character_light_cell_trigger_radius_multipliers: Array
var jetpack_thrust: float
var jetpack_velocity_modifier: Curve
var jetpack_jump_speed_modifier: float
var jetpack_wall_jump_speed_modifier: float
var jetpack_horizontal_forced_speed: float
var jetpack_death_spiral_up_accel: float
var jetpack_death_spiral_center_accel: float
var jetpack_death_spiral_rps: float
var jetpack_death_spiral_time: float
var jetpack_death_spiral_noise: float
var jet_pack_death_spiral_decay: Curve
var jetpack_win_spiral_up_accel: float
var jetpack_win_spiral_center_accel: float
var jetpack_win_spiral_rps: float
var jetpack_win_spiral_time: float
var jetpack_win_spiral_noise: float
var jet_pack_win_spiral_decay: Curve
var agony_time_limit_invisible: int
var agony_time_limit: int
var zombification_speed_multiplier: float
var zombie_animator_speed: float
var zombification_time: float
var zombification_jump_speed_multiplier: float
var doomsday_modifier_times: Array
var per_level_lava_settings: Array
var doomsday_meteors_easy_seconds: int
var doomsday_meteors_full_ramp_up_seconds: int
var doomsday_lava_rise_speed: float
var frictionless_friction_value: float
var player_collisions_start_invincibility_time: float
var gravity_mode: int
var jump_speed_mode: int
var sprint_speed_mode: int
var wall_jumps_disabled: bool
var wall_slides_disabled: bool
var game_speed_mode: int
var dance_invincibility: bool
var invisibility_mode: int
var mirror_controls: bool
var platform_speed_mode: int
var rate_of_fire_mode: int
var multi_jump_mode: int
var projectile_explosion_mode: int
var character_size_mode: int
var jetpack_mode: bool
var post_death_behavior_mode: int
var camera_flip_mode: int
var doomsday_meteors_mode: int
var doomsday_lava_mode: int
var player_player_collisions: bool
var projectile_speed_mode: int
var frictionless: bool
static var default_mod_source: ModSource
static var any_mods_printed: bool
static var string_builder
var gravity: float  # C# property
var u_gravity_scale: float  # C# property
var jump_speed: float  # C# property
var wall_jump_horizontal_push: float  # C# property
var wall_jump_vertical_push: float  # C# property
var sprint_speed: float  # C# property
var game_speed: float  # C# property
var invisible_when_moving: bool  # C# property
var invisible_when_stationary: bool  # C# property
var platform_move_speed: float  # C# property
var rotator_speed: float  # C# property
var rate_of_fire: float  # C# property
var projectile_speed: float  # C# property
var max_air_jumps: int  # C# property
var projectiles_explode: bool  # C# property
var projectile_explosion_scale: float  # C# property
var character_scale: float  # C# property
var character_relative_scale: float  # C# property
var character_scale_audio_state_string: String  # C# property
var character_size_speed_multiplier: float  # C# property
var character_size_zoom_multiplier: float  # C# property
var character_light_cell_trigger_radius_multiplier: float  # C# property
var post_death_behavior  # C# property
var camera_flipping  # C# property
var camera_flipped_on_x: bool  # C# property
var camera_flipped_on_y: bool  # C# property
var camera_flipped_on_single_axis: bool  # C# property
var doomsday_meteors_delay: int  # C# property
var doomsday_lava_delay: int  # C# property
var doomsday_meteors_enabled: bool  # C# property
var doomsday_lava_enabled: bool  # C# property
var is_non_default: bool  # C# property
var applied_and_non_default: bool  # C# property

static func load_modifiers_asset(on_success: Callable, on_fail: Callable) -> void:  # C# LoadModifiersAsset
	pass

static func get_instance() -> Modifiers:  # C# GetInstance
	return null

func on_modifiers_dynamic_change() -> void:  # C# OnModifiersDynamicChange
	pass

static func get_gravity_value_string(gravity_mode: int) -> String:  # C# GetGravityValueString
	return ""

static func get_jump_speed_value_string(jump_speed_mode: int) -> String:  # C# GetJumpSpeedValueString
	return ""

static func get_sprint_speed_value_string(sprint_speed_mode: int) -> String:  # C# GetSprintSpeedValueString
	return ""

static func get_multi_jump_value_string(multi_jump_mode: int) -> String:  # C# GetMultiJumpValueString
	return ""

static func get_on_off_value_string(on_off: bool) -> String:  # C# GetOnOffValueString
	return ""

static func get_projectile_explosion_value_string(projectile_explosion_mode: int) -> String:  # C# GetProjectileExplosionValueString
	return ""

static func get_character_size_value_string(character_size_mode: int) -> String:  # C# GetCharacterSizeValueString
	return ""

static func get_post_death_behavior_value_string(post_death_behavior_mode: int) -> String:  # C# GetPostDeathBehaviorValueString
	return ""

static func get_camera_flip_value_string(camera_flip_mode: int) -> String:  # C# GetCameraFlipValueString
	return ""

static func get_doomsday_meteors_value_string(doomsday_meteors_mode: int, doomsday_meteors_delay: int) -> String:  # C# GetDoomsdayMeteorsValueString
	return ""

static func get_doomsday_lava_value_string(doomsday_lava_mode: int, doomsday_lava_delay: int) -> String:  # C# GetDoomsdayLavaValueString
	return ""

static func get_invisibility_mode_value_string(invisibility_mode: int) -> String:  # C# GetInvisibilityModeValueString
	return ""

static func begin_mod_string() -> void:  # C# BeginModString
	pass

static func add_mod_string(mod_name: String, mod_value: String) -> void:  # C# AddModString
	pass

static func end_mod_string() -> void:  # C# EndModString
	pass

func get_current_modifier_list_string(force_mods_applied: bool) -> String:  # C# GetCurrentModifierListString
	return ""

func find_lava_settings_for_level(level):  # C# FindLavaSettingsForLevel
	pass
