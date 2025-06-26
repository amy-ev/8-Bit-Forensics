extends TextureRect


func _on_pc_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://pc/pc_screen.tscn")
