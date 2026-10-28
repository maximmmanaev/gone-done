# Ported from structur/PS2DTriangulator.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name PS2DTriangulator
extends RefCounted

var m_points: Array

func triangulate() -> Array:  # C# Triangulate
	return []

func area() -> float:  # C# Area
	return 0.0

func snip(u: int, v: int, w: int, n: int, v_: Array) -> bool:  # C# Snip
	return false

func inside_triangle(a: Vector2, b: Vector2, c: Vector2, p: Vector2) -> bool:  # C# InsideTriangle
	return false
