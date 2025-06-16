extends File

@onready var _image_viewer = preload("res://viewer/image_viewer.tscn")

func _process(delta: float) -> void:
	pass
	
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.is_double_click():
			var image_viewer = _image_viewer.instantiate()
			get_parent().add_child(image_viewer)
