extends File


@onready var _file_dialog = preload("res://file_dialog/load_file.tscn")

func _process(delta: float) -> void:
	pass


func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.is_double_click():
			print("ayyooo")
			var file_dialog = _file_dialog.instantiate()
			get_parent().add_child(file_dialog)
