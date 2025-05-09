extends Node2D

@onready var _file_dialog = preload("res://file_dialog/load_file.tscn")


func _on_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		var file_dialog = _file_dialog.instantiate()
		add_child(file_dialog)
