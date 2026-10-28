# Ported from structur/MsgSetNetworkSurrogateVal.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name MsgSetNetworkSurrogateVal
extends RefCounted

var net_surrogate_id
static var void_: int
static var u_bool: int
static var u_int: int
static var u_float: int
static var u_string: int
static var trigger: int
var value_type: int
var bool_val: bool
var int_val: int
var float_val: float
var string_val: String

func serialize(writer) -> void:  # C# Serialize
	pass

func deserialize(reader) -> void:  # C# Deserialize
	pass
