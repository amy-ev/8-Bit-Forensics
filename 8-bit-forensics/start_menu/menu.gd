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

	get_tree().change_scene_to_file("res://main/credits.tscn")


func _on_audio_pressed() -> void:
	pass # Replace with function body.


func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		audio.background.set_volume_db(-80.0) 
	else:
		audio.background.set_volume_db(-11.0) 


func _on_audio_toggled(toggled_on: bool) -> void:
	if toggled_on:
		audio.dialogue.set_volume_db(-80.0) 
		audio.dialogue_2.set_volume_db(-80.0) 
		audio.select.set_volume_db(-80.0) 
		
	else:
		audio.dialogue.set_volume_db(0.0) 
		audio.dialogue_2.set_volume_db(0.0) 
		audio.select.set_volume_db(0.0) 


func _on_audio_mouse_entered() -> void:
	audio.select.play(0.04)

func _on_music_mouse_entered() -> void:
	audio.select.play(0.04)
