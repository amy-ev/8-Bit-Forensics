extends TextureRect

func _ready() -> void:
	if Global.unlocked >= 3:
		$menu/start.disabled = true

func _on_start_pressed() -> void:
	Global.day_start()
	#get_tree().change_scene_to_file("res://main/desk.tscn")
	#get_tree().change_scene_to_file("res://opening/waking_up.tscn")
	get_tree().change_scene_to_file("res://opening/train.tscn")
	#get_tree().change_scene_to_file("res://pc/pc_screen.tscn")

func _on_information_pressed() -> void:
	get_tree().change_scene_to_file("res://crime_board/board.tscn")

func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://level_select/desk.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")
