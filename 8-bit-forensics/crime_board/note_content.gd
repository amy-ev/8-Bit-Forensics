extends Control


func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		queue_free()
