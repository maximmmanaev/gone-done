# Ported from structur/UndergroundComputer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name UndergroundComputer
extends Node2D

class LevelSignSprite extends RefCounted:
	var level
	var sprite: Texture2D

class FeaturedLevelData extends RefCounted:
	var u_name: String
	var author_name: String
	var author_id: String
	var author_id_old: String
	var author_platform_ids: Dictionary
	var code: String
	var play_count: int
	var get_count: int
	var timestamp: int
	var my_vote: int
	var rating: int
	var is_published: bool
	var level_type
	var attempted_players: int
	var successful_players: int
	var completion_rate: float
	var attempts: int
	var successes: int
	var archived: bool
	var has_mods: bool
	var is_local: bool
	var num_reports: int
	var approval_status: int
	var has_new_reports: bool
	var ignore_reports: bool
	var difficulty_string: String  # C# property
	var completion_percentage: int  # C# property
	var success_failure_rate: float  # C# property
	var success_failure_percentage: int  # C# property
	func fill_from_gs_data_record(record) -> void:  # C# FillFromGSDataRecord
		pass

class DisplaySlotPageDef extends RefCounted:
	var build_page
	var list_view_slot_def
	var grid_view_slot_def
	func get_current_entry_slots() -> Array:  # C# GetCurrentEntrySlots
		return []
	func get_current_entry_prefab():  # C# GetCurrentEntryPrefab
		pass

class DisplaySlotDef extends RefCounted:
	var entry_prefab
	var slot_container: Node2D
	var slots: Array

enum ViewModes {
	Grid,
	List,
}

class Breadcrumbs extends RefCounted:
	var selected_tab
	var main_dropdown_index: int
	var date_cutoff_dropdown_index: int
	var difficulty_dropdown_index: int
	var level_type_dropdown_index: int
	var page_number: int
	var showing_info_pane: bool
	var level_code: String
	var local_filename: String
	var leaderboard_num_players: int
	var player_info
	var show_mods: int
	func get_debug_info() -> String:  # C# GetDebugInfo
		return ""

enum FeaturedLevelTopPanelModes {
	QuickFilters,
	AdvancedSearch,
	PlayerLevels,
	MyLevels,
}
var level_sign_sprites: Array
var display_slot_defs: Array
var per_page_display_slot_defs: Dictionary
static var current_view_mode
static var last_computer_state
var featured_level_entries: Array
var total_featured_entries: int
var first_featured_entry_index: int
var auto_select_index_on_refresh: int
var auto_select_code_on_refresh: String
var auto_select_level_name_on_refresh: String
var last_displayed_user_info
var local_save_filenames: Array
var current_page_numbers: Dictionary
var waiting_for_file_operation: Dictionary
var refreshing_local_saves_list: bool
var code_entry_field
var code_status_text
var code_status_checkmark
var code_archived_text
var code_save_local_copy
@export var current_code_validated: bool
@export var current_code_archived: bool
var current_code_associated_xml: String
var current_code_associated_name: String
var current_code_author_info
var current_code_level_type
var current_query
var next_button
var prev_button
@export var page_indicator: Label
var slot_portals: Array
@export var computer_slots_container: Node2D
var computer_slots: Array
@export var tab_container: Node2D
var tabs: Array
@export var spinny_loading_thing: Sprite2D
var loading_operations: int
var computer_disabled: bool
var metadata_list: PlaceableMetadataList
var top_panel_mode
@export var main_row_container: Node2D
@export var main_filter_container: Node2D
@export var player_levels_container: Node2D
var quick_info_pane
@export var featured_quick_info_enabled: bool
var current_level_type
var my_levels_quick_filter
var current_filter
var previous_filter
var previous_page: int
var previous_panel_mode
var player_levels_name_tag
var previous_tab
var previous_selected_entry
var share_dialog
var report_dialog
var view_reports_dialog
var admin_panel_dialog
var admin_panel_button
@export var admin_panel_container: Node2D
var admin_panel_prefab
@export var admin_flagged_level_controls: Node2D
var admin_approval_status_dropdown
var admin_hide_acknowledged_button
@export var admin_hide_acknowledged_checkmark: TextureRect
@export var admin_hide_acknowledged_reports: bool
@export var cutoff_days: int
@export var lower_difficulty_bound: float
@export var upper_difficulty_bound: float
@export var allow_unpublished: bool
@export var allow_unpublished_admin_text: TextureRect
@export var show_mods: int
var show_mods_button
@export var show_mods_tip_text: Label
@export var show_mods_overlay_yes_image: TextureRect
@export var show_mods_overlay_no_image: TextureRect
@export var show_published_yes_image: TextureRect
var main_filter_dropdown
var level_type_dropdown
var date_cutoff_dropdown
var difficulty_dropdown
var featured_level_codes: Array
var advanced_search_box
var advanced_search_button
var last_filtered_search_query: String
var last_filtered_search_query_result: String
var never_opened: bool
var right_stick_values: Dictionary
@export var featured_content_rect: Node2D
@export var featured_restricted_message_rect: Node2D
@export var featured_access_restricted_message: Node2D
@export var featured_not_connected_message: Node2D
@export var featured_not_connected_retry_button: Node2D
@export var featured_access_restricted_all_ugc_message: Node2D
@export var hiding_online_content: bool
var user_info_popup_prefab
var user_info_popup
var delete_dialogue
static var last_refresh_timestamp: int
static var quick_play_mode
var currently_loading: bool  # C# property
var waiting_for_file_operation_on_current_page: bool  # C# property
var showing_empty_page: bool  # C# property
var num_pages: int  # C# property
var should_show_prev: bool  # C# property
var should_show_next: bool  # C# property
var should_show_page_number: bool  # C# property
var current_page: int  # C# property
var should_show_published_mark: bool  # C# property
var is_in_submenu: bool  # C# property

func _enter_tree() -> void:  # C# Awake
	pass

func initialize_0() -> void:  # C# Initialize
	pass

func on_first_opened() -> void:  # C# OnFirstOpened
	pass

func on_reopened() -> void:  # C# OnReopened
	pass

func auto_populate_slots(slot_container: Node2D, slot_transform_array: Array) -> void:  # C# AutoPopulateSlots
	pass

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func update_visibility() -> void:  # C# UpdateVisibility
	pass

func refresh_local_saves_list(keep_page: bool, on_finish: Callable) -> void:  # C# RefreshLocalSavesList
	pass

static func clear_missing_local_snapshot_code_entries(save_file_data) -> void:  # C# ClearMissingLocalSnapshotCodeEntries
	pass

func populate_featured_level_entries_from_recent(start_idx: int, on_finish: Callable) -> void:  # C# PopulateFeaturedLevelEntriesFromRecent
	pass

func populate_featured_level_entries_from_local_saves(start_index: int) -> void:  # C# PopulateFeaturedLevelEntriesFromLocalSaves
	pass

func set_local_level_entry(entry_idx: int, filename_without_ext: String) -> void:  # C# SetLocalLevelEntry
	pass

func populate_featured_level_entries_from_favourites(start_index: int, on_finish: Callable) -> void:  # C# PopulateFeaturedLevelEntriesFromFavourites
	pass

func update_page_indicator() -> void:  # C# UpdatePageIndicator
	pass

func refresh_current_page() -> void:  # C# RefreshCurrentPage
	pass

func auto_select_in_one_frame_1(idx: int):  # C# AutoSelectInOneFrame (coroutine)
	pass

func auto_select_in_one_frame_2(code: String, level_name: String):  # C# AutoSelectInOneFrame (coroutine)
	pass

func on_select_level_codes_tab() -> void:  # C# OnSelectLevelCodesTab
	pass

func on_select_featured_level_tab(refresh_current_page: bool, reset_filters: bool) -> void:  # C# OnSelectFeaturedLevelTab
	pass

func open_special_filter_page(filter_type) -> void:  # C# OpenSpecialFilterPage
	pass

func on_click_prev() -> void:  # C# OnClickPrev
	pass

func on_click_next() -> void:  # C# OnClickNext
	pass

func clamp_current_page_number() -> void:  # C# ClampCurrentPageNumber
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass

func renamed_local_level(button, pick_cursor: PickCursor) -> void:  # C# RenamedLocalLevel
	pass

func get_on_rename_callback(button) -> Callable:  # C# GetOnRenameCallback
	return Callable()

func rename_snapshot_thumbnail(original_name: String, new_name: String) -> void:  # C# RenameSnapshotThumbnail
	pass

func update_level_portal_info(original_name: String, new_name: String, save_file_data) -> void:  # C# updateLevelPortalInfo
	pass

func is_filename_valid(file_name: String) -> bool:  # C# IsFilenameValid
	return false

func get_page_number_for_file_entry(filename_without_extension: String) -> int:  # C# GetPageNumberForFileEntry
	return 0

func on_click_confirm_delete_local_file() -> void:  # C# OnClickConfirmDeleteLocalFile
	pass

func activate_code_entry_field(pick_cusor: CursorUnity) -> void:  # C# ActivateCodeEntryField
	pass

func on_code_entry_field_changed(str: String) -> void:  # C# OnCodeEntryFieldChanged
	pass

func on_code_entry_field_submitted(str: String) -> void:  # C# OnCodeEntryFieldSubmitted
	pass

func reset_code_entry_status() -> void:  # C# ResetCodeEntryStatus
	pass

func get_code_query_return_func(query, code_input: String) -> Callable:  # C# GetCodeQueryReturnFunc
	return Callable()

func on_code_query_return(query, code_input: String) -> void:  # C# OnCodeQueryReturn
	pass

func wait_for_loading_operations():  # C# WaitForLoadingOperations (coroutine)
	pass

func open_level_info_for_recent_code(code_input: String):  # C# OpenLevelInfoForRecentCode (coroutine)
	pass

func load_current_code_into_slot(slot, select_entry, on_finish: Callable) -> void:  # C# LoadCurrentCodeIntoSlot
	pass

func get_sprite_for_level(level_enum) -> Texture2D:  # C# GetSpriteForLevel
	return null

func load_current_local_save_into_slot(button, slot, select_entry, on_finish: Callable) -> void:  # C# LoadCurrentLocalSaveIntoSlot
	pass

func load_current_recent_code_into_slot(button, slot, select_entry, on_finish: Callable) -> void:  # C# LoadCurrentRecentCodeIntoSlot
	pass

func load_current_favorite_into_portal_slot(button, slot, select_entry, on_finish: Callable) -> void:  # C# LoadCurrentFavoriteIntoPortalSlot
	pass

func load_snapshot_into_portal_slot(slot, xml: String, code: String, name: String, portal_idx: int, level_type, author_info, select_entry: bool) -> void:  # C# LoadSnapshotIntoPortalSlot
	pass

func get_code_for_local_save(button, on_finish: Callable) -> void:  # C# GetCodeForLocalSave
	pass

func get_portal_idx_from_slot(slot_enum) -> int:  # C# GetPortalIdxFromSlot
	return 0

func get_portal_for_slot(slot_enum):  # C# GetPortalForSlot
	pass

func is_portal_populated(slot_enum) -> bool:  # C# IsPortalPopulated
	return false

func is_any_portal_populated() -> bool:  # C# IsAnyPortalPopulated
	return false

func name_of_snap_shot_in_slot(slot_enum) -> String:  # C# nameOfSnapShotInSlot
	return ""

func get_slots_containing_snapshot(code: String, level_name: String) -> Array:  # C# GetSlotsContainingSnapshot
	return []

func snapshot_already_loaded(entry) -> bool:  # C# SnapshotAlreadyLoaded
	return false

func code_already_loaded(code: String) -> bool:  # C# CodeAlreadyLoaded
	return false

func code_already_loaded_in_slot(code: String, slot_enum) -> bool:  # C# CodeAlreadyLoadedInSlot
	return false

func snapshot_already_loaded_in_slot(entry, slot_enum) -> bool:  # C# SnapshotAlreadyLoadedInSlot
	return false

func code_entry_matches_loaded_code_in_slot(slot_enum) -> bool:  # C# CodeEntryMatchesLoadedCodeInSlot
	return false

func code_entry_already_loaded() -> bool:  # C# CodeEntryAlreadyLoaded
	return false

func on_click_clear_code(slot_enum) -> void:  # C# OnClickClearCode
	pass

func clear_all_slots() -> void:  # C# ClearAllSlots
	pass

func delete_recent_code(button) -> void:  # C# DeleteRecentCode
	pass

func remove_favorite(button) -> void:  # C# RemoveFavorite
	pass

func create_local_save_from_recent_entry(button) -> void:  # C# CreateLocalSaveFromRecentEntry
	pass

func save_local_copy(name: String, snapshot_code: String, xml_bytes, level_type) -> void:  # C# SaveLocalCopy
	pass

func copy_code_to_clipboard(button) -> void:  # C# CopyCodeToClipboard
	pass

func on_select_entry(button) -> void:  # C# OnSelectEntry
	pass

func on_select_level_slot(button) -> void:  # C# OnSelectLevelSlot
	pass

func find_snapshot_in_display_list(code: String, snapshot_name: String) -> SnapshotEntry:  # C# FindSnapshotInDisplayList
	return null

func set_favorite_button_state(is_favorite: bool) -> void:  # C# SetFavoriteButtonState
	pass

func toggle_favorite(button) -> void:  # C# ToggleFavorite
	pass

func get_pick_cursor_for_controller(sender: Controller) -> PickCursor:  # C# GetPickCursorForController
	return null

func receive_event(e: InputEventUnity) -> void:  # C# ReceiveEvent
	pass

func get_current_tab_index() -> int:  # C# GetCurrentTabIndex
	return 0

func add_waiting_for_file_operation(state) -> void:  # C# AddWaitingForFileOperation
	pass

func remove_waiting_for_file_operation(state) -> void:  # C# RemoveWaitingForFileOperation
	pass

func descramble_file(button) -> void:  # C# DescrambleFile
	pass

static func share_snapshot_code_on_reddit(snapshot_name: String, code: String, image_url: String) -> void:  # C# ShareSnapshotCodeOnReddit
	pass

static func share_snapshot_code_on_imgur(image_url: String) -> void:  # C# ShareSnapshotCodeOnImgur
	pass

static func share_snapshot_code_on_twitter(snapshot_name: String, code: String, image_url: String) -> void:  # C# ShareSnapshotCodeOnTwitter
	pass

func add_loading_operation() -> void:  # C# AddLoadingOperation
	pass

func remove_loading_operation() -> void:  # C# RemoveLoadingOperation
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func try_refresh_current_screen() -> void:  # C# TryRefreshCurrentScreen
	pass

func paste_code_from_clipboard() -> void:  # C# PasteCodeFromClipboard
	pass

func update_featured_level_view(start_index: int) -> void:  # C# UpdateFeaturedLevelView
	pass

func on_click_quick_filter(filter, force_page: int) -> void:  # C# OnClickQuickFilter
	pass

func set_top_panel_mode(mode) -> void:  # C# SetTopPanelMode
	pass

func refresh_snapshot_metadata(snapshot_entry: SnapshotEntry, on_refresh: Callable) -> void:  # C# RefreshSnapshotMetadata
	pass

func show_quick_level_info(snapshot_entry: SnapshotEntry) -> void:  # C# ShowQuickLevelInfo
	pass

func set_featured_level_mode(level_type, refresh_search: bool) -> void:  # C# SetFeaturedLevelMode
	pass

func refresh_search(keep_page: bool) -> void:  # C# RefreshSearch
	pass

func clear_featured_level_page() -> void:  # C# ClearFeaturedLevelPage
	pass

func show_levels_by_player(player_name: String, player_platform_id: String, filter, social_platform, is_anonymous: bool, is_me: bool, start_page: int) -> void:  # C# ShowLevelsByPlayer
	pass

func show_my_levels(sorting_filter) -> void:  # C# ShowMyLevels
	pass

func close_levels_by_player() -> void:  # C# CloseLevelsByPlayer
	pass

func get_current_slot_page_def():  # C# GetCurrentSlotPageDef
	pass

func get_current_entry_slots() -> Array:  # C# GetCurrentEntrySlots
	return []

func set_featured_view_mode(view_mode, refresh_search: bool) -> void:  # C# SetFeaturedViewMode
	pass

func open_share_dialog(button) -> void:  # C# OpenShareDialog
	pass

func close_share_dialog() -> void:  # C# CloseShareDialog
	pass

func open_view_reports_dialog(button) -> void:  # C# OpenViewReportsDialog
	pass

func close_view_reports_dialog() -> void:  # C# CloseViewReportsDialog
	pass

static func time_to_string(total_seconds: int) -> String:  # C# TimeToString
	return ""

static func plural_from_count(count: int, singular: String, plural: String) -> String:  # C# PluralFromCount
	return ""

func on_click_upvote() -> void:  # C# OnClickUpvote
	pass

func on_click_downvote() -> void:  # C# OnClickDownvote
	pass

func cast_vote(vote: int) -> void:  # C# CastVote
	pass

func on_click_allow_unpublished_toggle() -> void:  # C# OnClickAllowUnpublishedToggle
	pass

func set_allow_unpublished_toggle(value: bool, refresh_search: bool) -> void:  # C# SetAllowUnpublishedToggle
	pass

func on_click_show_mods_toggle() -> void:  # C# OnClickShowModsToggle
	pass

func set_show_mods(val: int, refresh_search: bool) -> void:  # C# SetShowMods
	pass

func update_single_entry(selected_entry) -> void:  # C# UpdateSingleEntry
	pass

func open_report_dialog(button) -> void:  # C# OpenReportDialog
	pass

func close_report_dialog() -> void:  # C# CloseReportDialog
	pass

func open_delete_dialog(button) -> void:  # C# OpenDeleteDialog
	pass

func close_delete_dialog() -> void:  # C# CloseDeleteDialog
	pass

func on_click_delete_confirm() -> void:  # C# OnClickDeleteConfirm
	pass

func on_main_filter_dropdown_value_change() -> void:  # C# OnMainFilterDropdownValueChange
	pass

func refresh_main_filter(goto_page: int) -> void:  # C# RefreshMainFilter
	pass

func update_level_type_from_dropdown_values(refresh_page: bool) -> void:  # C# UpdateLevelTypeFromDropdownValues
	pass

func on_level_type_dropdown_value_change() -> void:  # C# OnLevelTypeDropdownValueChange
	pass

func update_date_cutoff_from_dropdown_values() -> void:  # C# UpdateDateCutoffFromDropdownValues
	pass

func on_date_cutoff_dropdown_value_change() -> void:  # C# OnDateCutoffDropdownValueChange
	pass

func update_difficulty_from_dropdown_values() -> void:  # C# UpdateDifficultyFromDropdownValues
	pass

func on_difficulty_dropdown_value_change() -> void:  # C# OnDifficultyDropdownValueChange
	pass

func activate_advanced_search_field(pickcursor: CursorUnity) -> void:  # C# ActivateAdvancedSearchField
	pass

func sanitize_search_query(str: String) -> String:  # C# SanitizeSearchQuery
	return ""

func on_advanced_search_field_submitted(str: String) -> void:  # C# OnAdvancedSearchFieldSubmitted
	pass

func on_click_advanced_search_erase() -> void:  # C# OnClickAdvancedSearchErase
	pass

func do_advanced_search(str: String) -> void:  # C# DoAdvancedSearch
	pass

func is_tab_highlighted(job) -> bool:  # C# IsTabHighlighted
	return false

func mask_all_but_tabs() -> void:  # C# MaskAllButTabs
	pass

func on_click_retry_connect_button() -> void:  # C# OnClickRetryConnectButton
	pass

func popup_name_options(users: Array) -> void:  # C# PopupNameOptions
	pass

func back_out_of_submenu(auto_closing: bool) -> void:  # C# BackOutOfSubmenu
	pass

func close_computer_and_warp_to_portal(pick_cursor: PickCursor, portal_idx: int) -> void:  # C# CloseComputerAndWarpToPortal
	pass

func on_click_play_now(pick_cursor: PickCursor, suggested: bool) -> void:  # C# OnClickPlayNow
	pass

func on_click_save_archived_level() -> void:  # C# OnClickSaveArchivedLevel
	pass

func on_click_open_admin_dialog() -> void:  # C# OnClickOpenAdminDialog
	pass

func close_admin_dialog() -> void:  # C# CloseAdminDialog
	pass

static func suggest_quick_play_mode(mode) -> void:  # C# SuggestQuickPlayMode
	pass

static func next_quick_play_mode() -> void:  # C# NextQuickPlayMode
	pass

static func prev_quick_play_mode() -> void:  # C# PrevQuickPlayMode
	pass

func on_admin_approval_status_dropdown_value_change() -> void:  # C# OnAdminApprovalStatusDropdownValueChange
	pass

func on_click_admin_hide_acknowledged(pick_cursor: PickCursor) -> void:  # C# OnClickAdminHideAcknowledged
	pass

func memorize_breadcrumbs() -> void:  # C# MemorizeBreadcrumbs
	pass
