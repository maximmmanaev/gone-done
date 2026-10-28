# Ported from structur/PhysicsModifier.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PhysicsModifier
extends RefCounted

enum ModType {
	BaseMotion,
	Rotation,
	Gravity,
	GroundFriction,
	WallFriction,
	Friction,
	JumpForce,
	AirInertia,
	AirInertiaLeft,
	AirInertiaRight,
	Blackhole,
	Treadmill,
	Wind,
}
var modifier_type
var magnitude: float
var direction: Vector2
var elapsed: float
var switch: bool
var mode: int
var source: Node2D
