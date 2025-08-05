extends Label

var draw_allowed:bool = false

func _ready() -> void:
	$select/select_shape.position.x = $select/select_shape.shape.size.x / 2


func _process(delta: float) -> void:
	pass
	if minimum_size_changed:
		if self.has_node("select"):
			$select/select_shape.position.x = $select/select_shape.shape.size.x / 2

func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.emit_signal("metadata_selected",$".")
		Global.emit_signal("metadata_help", get_parent())
