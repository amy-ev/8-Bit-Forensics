extends Control

@onready var text_rect = $pc_screen
@onready var _file_dialog = preload("res://file_dialog/load_file.tscn")

func _ready() -> void:
	var file_dialog = _file_dialog.instantiate()
	add_child(file_dialog)
	update_size()
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()

func update_size():
	var original_size = size
	size = DisplayServer.window_get_size()
	text_rect.size = size

	print(original_size/size)
	print(DisplayServer.window_get_size())
