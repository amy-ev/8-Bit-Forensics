extends CanvasLayer


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_cancel_pressed() -> void:
	queue_free()


func _on_audio_toggled(toggled_on: bool) -> void:
	if toggled_on:
		audio.dialogue.set_volume_db(-80.0) 
		audio.dialogue_2.set_volume_db(-80.0) 
		audio.select.set_volume_db(-80.0) 
		
	else:
		audio.dialogue.set_volume_db(0.0) 
		audio.dialogue_2.set_volume_db(0.0) 
		audio.select.set_volume_db(0.0) 

func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		audio.background.set_volume_db(-80.0) 
	else:
		audio.background.set_volume_db(-11.0) 

func _on_music_mouse_entered() -> void:
	audio.select.play(0.04)

func _on_audio_mouse_entered() -> void:
	audio.select.play(0.04)
