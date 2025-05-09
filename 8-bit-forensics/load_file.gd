extends Control


func _on_load_button_pressed() -> void:
	pass
	


func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	
