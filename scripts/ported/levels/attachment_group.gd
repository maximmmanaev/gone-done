# Ported from structur/AttachmentGroup.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name AttachmentGroup
extends RefCounted

var links: Array
var top_node: AttachmentNode
var drawing_debug: bool
var id: int
static var sequence_number: int
var top_parent: Placeable  # C# property
var piece_count: int  # C# property
var contains_set_pieces: bool  # C# property
var contains_non_set_pieces: bool  # C# property
var contains_mixed_pieces: bool  # C# property
var all_nodes: Array  # C# property

func force_add_link(a: Placeable, b: Placeable) -> void:  # C# ForceAddLink
	pass

func add_link_no_attach(in_group: Placeable, new_piece: Placeable, new_is_top: bool) -> bool:  # C# AddLinkNoAttach
	return false

func add_link_3(in_group: Placeable, new_piece: Placeable, new_is_top: bool) -> bool:  # C# AddLink
	return false

func add_link_1(link) -> bool:  # C# AddLink
	return false

func set_top_parent(n: AttachmentNode) -> void:  # C# SetTopParent
	pass

func u_is_connected(p: Placeable) -> AttachmentNode:  # C# IsConnected
	return null

func is_connected_to(root: AttachmentNode, p: Placeable) -> AttachmentNode:  # C# isConnectedTo
	return null

func destroy_group() -> void:  # C# DestroyGroup
	pass

func reset_marks() -> void:  # C# ResetMarks
	pass

func reset_debug() -> void:  # C# ResetDebug
	pass

func get_group_physics_modifier() -> Array:  # C# GetGroupPhysicsModifier
	return []

static func merge_groups(g_1: AttachmentGroup, g_2: AttachmentGroup) -> AttachmentGroup:  # C# MergeGroups
	return null

func draw_links() -> void:  # C# DrawLinks
	pass

func set_piece_connected(p: Placeable) -> bool:  # C# SetPieceConnected
	return false

func find_nodes_for_placeable(p: Placeable) -> Array:  # C# FindNodesForPlaceable
	return []

func find_node_for_placeable(p: Placeable) -> AttachmentNode:  # C# FindNodeForPlaceable
	return null

func find_first_connected_set_piece(p: Placeable) -> Placeable:  # C# FindFirstConnectedSetPiece
	return null

func remove_placeable(p: Placeable) -> void:  # C# RemovePlaceable
	pass

func clean_broken_links(nodes: Array) -> void:  # C# CleanBrokenLinks
	pass

func simplify_nodes() -> void:  # C# SimplifyNodes
	pass
