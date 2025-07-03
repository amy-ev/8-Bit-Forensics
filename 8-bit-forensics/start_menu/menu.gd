extends TextureRect

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://opening/waking_up.tscn")

func _on_information_pressed() -> void:
	get_tree().change_scene_to_file("res://crime_board/board.tscn")

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select/desk.tscn")


func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action_pressed("fullscreen"):
		if !Global.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Global.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Global.fullscreen = false
