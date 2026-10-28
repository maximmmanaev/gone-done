# Ported from structur/ModSource.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name ModSource
extends RefCounted

var gravity_mode: int
var jump_speed_mode: int
var wall_jumps_disabled: bool
var wall_slides_disabled: bool
var sprint_speed_mode: int
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
var preview_mods_in_treehouse: bool
var force_lobby_modifiers: bool
var frictionless: bool

func read_from_mod_settings() -> void:  # C# ReadFromModSettings
	pass

func write_to_mod_settings(include_treehouse_settings: bool) -> void:  # C# WriteToModSettings
	pass

func is_currently_applied_0() -> bool:  # C# IsCurrentlyApplied
	return false

func has_default_values() -> bool:  # C# HasDefaultValues
	return false

func compare_to(other: ModSource) -> bool:  # C# CompareTo
	return false

func read_from_xml_node(child) -> void:  # C# ReadFromXmlNode
	pass

func write_to_xml_node(doc, mods_node) -> void:  # C# WriteToXmlNode
	pass

func clamp_numeric_values() -> void:  # C# ClampNumericValues
	pass
