# Ported from structur/Easings.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name Easings
extends RefCounted

enum Functions {
	Linear,
	QuadraticEaseIn,
	QuadraticEaseOut,
	QuadraticEaseInOut,
	CubicEaseIn,
	CubicEaseOut,
	CubicEaseInOut,
	QuarticEaseIn,
	QuarticEaseOut,
	QuarticEaseInOut,
	QuinticEaseIn,
	QuinticEaseOut,
	QuinticEaseInOut,
	SineEaseIn,
	SineEaseOut,
	SineEaseInOut,
	CircularEaseIn,
	CircularEaseOut,
	CircularEaseInOut,
	ExponentialEaseIn,
	ExponentialEaseOut,
	ExponentialEaseInOut,
	ElasticEaseIn,
	ElasticEaseOut,
	ElasticEaseInOut,
	BackEaseIn,
	BackEaseOut,
	BackEaseInOut,
	BounceEaseIn,
	BounceEaseOut,
	BounceEaseInOut,
}
var pi: float
var halfpi: float

static func interpolate(p: float, function) -> float:  # C# Interpolate
	return 0.0

static func linear(p: float) -> float:  # C# Linear
	return 0.0

static func quadratic_ease_in(p: float) -> float:  # C# QuadraticEaseIn
	return 0.0

static func quadratic_ease_out(p: float) -> float:  # C# QuadraticEaseOut
	return 0.0

static func quadratic_ease_in_out(p: float) -> float:  # C# QuadraticEaseInOut
	return 0.0

static func cubic_ease_in(p: float) -> float:  # C# CubicEaseIn
	return 0.0

static func cubic_ease_out(p: float) -> float:  # C# CubicEaseOut
	return 0.0

static func cubic_ease_in_out(p: float) -> float:  # C# CubicEaseInOut
	return 0.0

static func quartic_ease_in(p: float) -> float:  # C# QuarticEaseIn
	return 0.0

static func quartic_ease_out(p: float) -> float:  # C# QuarticEaseOut
	return 0.0

static func quartic_ease_in_out(p: float) -> float:  # C# QuarticEaseInOut
	return 0.0

static func quintic_ease_in(p: float) -> float:  # C# QuinticEaseIn
	return 0.0

static func quintic_ease_out(p: float) -> float:  # C# QuinticEaseOut
	return 0.0

static func quintic_ease_in_out(p: float) -> float:  # C# QuinticEaseInOut
	return 0.0

static func sine_ease_in(p: float) -> float:  # C# SineEaseIn
	return 0.0

static func sine_ease_out(p: float) -> float:  # C# SineEaseOut
	return 0.0

static func sine_ease_in_out(p: float) -> float:  # C# SineEaseInOut
	return 0.0

static func circular_ease_in(p: float) -> float:  # C# CircularEaseIn
	return 0.0

static func circular_ease_out(p: float) -> float:  # C# CircularEaseOut
	return 0.0

static func circular_ease_in_out(p: float) -> float:  # C# CircularEaseInOut
	return 0.0

static func exponential_ease_in(p: float) -> float:  # C# ExponentialEaseIn
	return 0.0

static func exponential_ease_out(p: float) -> float:  # C# ExponentialEaseOut
	return 0.0

static func exponential_ease_in_out(p: float) -> float:  # C# ExponentialEaseInOut
	return 0.0

static func elastic_ease_in(p: float) -> float:  # C# ElasticEaseIn
	return 0.0

static func elastic_ease_out(p: float) -> float:  # C# ElasticEaseOut
	return 0.0

static func elastic_ease_in_out(p: float) -> float:  # C# ElasticEaseInOut
	return 0.0

static func back_ease_in(p: float) -> float:  # C# BackEaseIn
	return 0.0

static func back_ease_out(p: float) -> float:  # C# BackEaseOut
	return 0.0

static func back_ease_in_out(p: float) -> float:  # C# BackEaseInOut
	return 0.0

static func bounce_ease_in(p: float) -> float:  # C# BounceEaseIn
	return 0.0

static func bounce_ease_out(p: float) -> float:  # C# BounceEaseOut
	return 0.0

static func bounce_ease_in_out(p: float) -> float:  # C# BounceEaseInOut
	return 0.0
