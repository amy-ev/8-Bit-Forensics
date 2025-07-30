extends TextureRect

func _on_start_pressed() -> void:
	Global.day_start()
	#get_tree().change_scene_to_file("res://main/desk.tscn")
	get_tree().change_scene_to_file("res://opening/waking_up.tscn")

func _on_information_pressed() -> void:
	get_tree().change_scene_to_file("res://crime_board/board.tscn")

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select/desk.tscn")
