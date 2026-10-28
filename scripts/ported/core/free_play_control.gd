# Ported from structur/FreePlayControl.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name FreePlayControl
extends GameControl

var placed_this_phase: Array
var tentative_phase

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func reset_player_character_2(c: Character, send_event: bool) -> void:  # C# resetPlayerCharacter
	pass

func reset_player_character_part_2(c: Character, send_event: bool):  # C# resetPlayerCharacterPart2 (coroutine)
	pass

func setup_start(mode) -> void:  # C# SetupStart
	pass

func do_start() -> void:  # C# DoStart
	pass

func to_place_mode_0() -> void:  # C# ToPlaceMode
	pass

func reset_all_blocks():  # C# resetAllBlocks (coroutine)
	pass

func re_enable_all_blocks():  # C# reEnableAllBlocks (coroutine)
	pass

func to_play_mode() -> void:  # C# ToPlayMode
	pass

func after_a_fixed_update() -> void:  # C# AfterAFixedUpdate
	pass

func send_end_analytics() -> void:  # C# sendEndAnalytics
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func wait_for_dance(network_number: int):  # C# waitForDance (coroutine)
	pass

func u_net_version() -> void:  # C# UNetVersion
	pass

func on_serialize(writer, force_all: bool) -> bool:  # C# OnSerialize
	return false

func on_deserialize(reader, initial_state: bool) -> void:  # C# OnDeserialize
	pass

func pre_start_client() -> void:  # C# PreStartClient
	pass
