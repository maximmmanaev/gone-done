class_name VectorLevel
extends RefCounted
## Векторный уровень: assets/levels/levelN.vec (см. tools/vectorize_levels.py) -> ArrayMesh.
## Меш состоит из цветных треугольников в пикселях мира, поэтому остаётся чётким при любом приближении камеры.

static func load_mesh(path: String) -> ArrayMesh:
	var raw := FileAccess.get_file_as_bytes(path)
	if raw.is_empty():
		push_error("Не прочитан уровень: " + path)
		return null
	# gzip: распаковываем с запасом (размер заранее неизвестен)
	var data := raw.decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP)
	if data.size() < 20 or data.slice(0, 4).get_string_from_ascii() != "GVEC":
		push_error("Неверный формат уровня: " + path)
		return null
	var nv := data.decode_u32(4)
	var ni := data.decode_u32(8)
	var pos := 20
	var verts := data.slice(pos, pos + nv * 8).to_vector2_array()
	pos += nv * 8
	var colors := data.slice(pos, pos + nv * 16).to_color_array()
	pos += nv * 16
	var indices := data.slice(pos, pos + ni * 4).to_int32_array()
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh


static func make_node(path: String) -> MeshInstance2D:
	var node := MeshInstance2D.new()
	node.mesh = load_mesh(path)
	return node
