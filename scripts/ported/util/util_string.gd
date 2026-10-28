# Ported from structur/Util_String.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Util_String
extends RefCounted

static func null_or_empty(str) -> bool:  # C# NullOrEmpty
	return false

static func compact_whitespaces(s) -> String:  # C# CompactWhitespaces
	return ""

static func compact_whitespaces_2(sb) -> void:  # C# CompactWhitespaces
	pass
