extends Control


func _on_load_button_pressed() -> void:
	$FileDialog.popup()
	


func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	
	var image_text = ImageTexture.new()
	image_text.set_image(image)
	
	$files/TextureRect.texture = image_text
	
