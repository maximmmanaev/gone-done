# Ported from structur/NetMsgTypes.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name NetMsgTypes
extends RefCounted

static var msg_count: int
static var network_client_connected: int
static var network_client_disconnected: int
static var game_rule_set: int
static var character_picked: int
static var set_block_frequency: int
static var set_all_block_frequencies: int
static var send_all_block_frequencies: int
static var party_box_open: int
static var party_box_closed: int
static var piece_picked: int
static var piece_placed: int
static var piece_destroyed: int
static var character_success: int
static var projectile_hit: int
static var trap_triggered: int
static var point_awarded: int
static var points_cleared: int
static var ready_to_tally_points: int
static var network_surrogate_spawned: int
static var set_network_surrogate_val: int
static var switch_to_mode: int
static var book_piece_picked: int
static var set_party_piece_id: int
static var client_loaded_treehouse: int
static var chat_sent: int
static var portal_has_unlock: int
static var unlock_available: int
static var client_kicked: int
static var vote_to_kick: int
static var connection_quality: int
static var lobby_voting: int
static var player_skill_updated: int
static var set_game_mode_lock: int
static var player_handicap_set: int
static var afk_player: int
static var piece_picked_up: int
static var snapshot_loading_done: int
static var show_credits: int
static var communicate_character_outfits: int
static var set_custom_portal_info: int
static var lobby_data_updated: int
static var set_custom_background: int
static var set_custom_music: int
static var update_vote_kick_counts: int
static var player_wants_to_retry: int
static var player_ready_to_start: int
static var prepare_to_reload_scene: int
static var set_custom_ambience: int
static var projectile_destroyed: int
static var host_ended_game: int
static var afk_timer_changed: int
static var punching_block_triggered: int
static var apply_ruleset: int
static var ruleset_dirty: int
static var forced_piece_spawned: int

static func get_message_name(message_type: int) -> String:  # C# GetMessageName
	return ""
