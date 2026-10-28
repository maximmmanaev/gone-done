# Ported from structur/PointBlock.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PointBlock
extends RefCounted

enum pointBlockType {
	win,
	winDead,
	soloWin,
	first,
	trap,
	suicide,
	comeback,
	coin,
	second,
	third,
	fourth,
}
var type
var player_number: int
var sfx_event_name: String
var suicide_value: int
var caused_by: Placeable
var always_award: bool  # C# property
var point_value: int  # C# property
