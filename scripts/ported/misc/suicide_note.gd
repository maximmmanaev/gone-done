# Ported from structur/SuicideNote.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name SuicideNote
extends UIGraphic

var note_canvas: CanvasLayer
@export var max_run_time: float
var run_time: float
var running: bool

func _ready() -> void:  # C# Start
	pass

func _exit_tree() -> void:  # C# OnDestroy
	pass

func change_listener(adding: bool) -> void:  # C# ChangeListener
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func show_0() -> void:  # C# Show
	pass

func hide_1(force_quick_hide: bool) -> void:  # C# Hide
	pass

func pause_0() -> void:  # C# Pause
	pass

func unpause_0() -> void:  # C# Unpause
	pass

func handle_event(e) -> void:  # C# handleEvent
	pass
