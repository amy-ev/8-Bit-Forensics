extends TextureRect

func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu/menu.tscn")
