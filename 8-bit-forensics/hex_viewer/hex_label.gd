extends Label

func _ready() -> void:
	$selected.size = size
	$select/select_shape.shape.size = size
	$select/select_shape.position.x = $select/select_shape.shape.size.x / 2
	
	
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.is_double_click():
			#TODO: connect to hex_viewer select
			var hex = preload("res://hex_viewer/select.tscn").instantiate()
			Global.emit_signal("hex_selected", hex._hex_to_dec(text)[0])
