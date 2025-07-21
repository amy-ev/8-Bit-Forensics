extends Label

var draw_allowed:bool = false

func _ready() -> void:
	
	#$select/select_shape.shape.size.x = custom_minimum_size.x
	$select/select_shape.position.x = $select/select_shape.shape.size.x / 2
	#$selected.size.x = custom_minimum_size.x

func _process(delta: float) -> void:
	pass
	if minimum_size_changed:
		#$select/select_shape.shape.size.x = custom_minimum_size.x
		if self.has_node("select"):
			$select/select_shape.position.x = $select/select_shape.shape.size.x / 2
		#$selected.size.x = custom_minimum_size.x
		
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.metadata_selected.emit($".")
