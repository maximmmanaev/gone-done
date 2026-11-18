class_name InventoryPickup
extends ActiveBlock
## Секундомер и ранцы подбираются один раз за забег, после подтверждения сервера.

signal touched(character: Character)

var _requested := false
var _taken := false


func act(_delta: float) -> void:
	if _requested or _taken:
		return
	for c: Character in zone_characters:
		if is_instance_valid(c) and c.active and not c.dead and not c.dying and not c.is_ghost and not c.success:
			_requested = true
			touched.emit(c)
			return


func confirm() -> void:
	_taken = true
	hide()


func reset_play_state() -> void:
	_requested = false
	_taken = false
	show()
