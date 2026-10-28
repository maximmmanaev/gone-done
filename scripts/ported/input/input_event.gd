# Ported from structur/InputEvent.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name InputEventUnity
extends RefCounted

enum InputKey {
	Up,
	Down,
	Left,
	Right,
	OrthoUp,
	OrthoDown,
	OrthoLeft,
	OrthoRight,
	Jump,
	Suicide,
	ChangeMode,
	Sprint,
	Inventory,
	Zoom,
	LeftTrigger,
	RightTrigger,
	RotateLeft,
	RotateRight,
	Start,
	Pause,
	Scoreboard,
	Accept,
	Back,
	NoKey,
	Up2,
	Down2,
	Left2,
	Right2,
	OrthoUp2,
	OrthoDown2,
	OrthoLeft2,
	OrthoRight2,
	VectorChanged,
	Chat,
	Esc,
	DpadUp,
	DpadDown,
	DpadLeft,
	DpadRight,
}
var sender: Controller
var consumed: bool
var player_bit_mask: int  # C# property
var key  # C# property
var valuef: float  # C# property
var valueb: bool  # C# property
var u_changed: bool  # C# property

func consume() -> void:  # C# Consume
	pass

func u_to_string() -> String:  # C# ToString
	return ""
