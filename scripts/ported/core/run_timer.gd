# Ported from structur/RunTimer.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name RunTimer
extends UIGraphic

var versus_controller: VersusControl
@export var round_start_time: float
var pause_start_time: float
var pause_time: float
var run_started: bool
var clock_shown: bool
var clock_tripped: bool
var paused: bool
var max_time: float
var always_show_clock: bool
@export var clock_container: Node2D
@export var clock_text: Label
@export var start_color: Color
@export var end_color: Color
var tripped: bool  # C# property
var time_left: float  # C# property

func _ready() -> void:  # C# Start
	pass

func on_start_run(time: float, always_show_clock: bool) -> void:  # C# OnStartRun
	pass

func pause_run() -> void:  # C# PauseRun
	pass

func unpause_run() -> void:  # C# UnpauseRun
	pass

func on_end_run() -> void:  # C# OnEndRun
	pass

func _process(delta: float) -> void:  # C# Update
	pass

func show_0() -> void:  # C# Show
	pass

func update_clock_time(seconds_left: float, color_time: float) -> void:  # C# UpdateClockTime
	pass

func hide_0() -> void:  # C# Hide
	pass
