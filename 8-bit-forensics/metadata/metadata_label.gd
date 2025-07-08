extends Label

var draw_allowed:bool = false

func _ready() -> void:
	
	#$select/select_shape.shape.size.x = custom_minimum_size.x
	$select/select_shape.position.x = $select/select_shape.shape.size.x / 2
	#$selected.size.x = custom_minimum_size.x

func _process(delta: float) -> void:
	if minimum_size_changed:
		#$select/select_shape.shape.size.x = custom_minimum_size.x
		if self.has_node("select"):
			$select/select_shape.position.x = $select/select_shape.shape.size.x / 2
		#$selected.size.x = custom_minimum_size.x
		
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.metadata_selected.emit($".")
		draw_allowed = true
		queue_redraw()
		
func _draw() -> void:
	if draw_allowed:
		print("woo")
		var pos_from = $selected.position + Vector2($selected.size.x,$selected.size.y/2)
		var pos_to = ($selected.position + Vector2($selected.size.x,$selected.size.y/2)) + Vector2(40,0)
		draw_dashed_line(pos_from, pos_to, Color.WHITE, 3.0,3.0)
