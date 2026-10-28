# Ported from structur/MsgSetCustomPortalInfo.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgSetCustomPortalInfo
extends RefCounted

var portal_id
var target_level
var snapshot_name: String
var code: String
var author_gsid: String
var author_display_name: String
var author_platform
var author_platform_id: String
var author_info  # C# property

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
