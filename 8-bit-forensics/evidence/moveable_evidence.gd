extends TextureRect

var is_picked_up:bool = false

func _on_moveable_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			is_picked_up = true
			pass
		if event.is_released():
			is_picked_up = false
			
func _process(delta: float) -> void:
	if is_picked_up:
		global_position = get_global_mouse_position() - (size / 2)
	else:
		global_position = global_position
