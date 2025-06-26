extends Control


func _on_change_scene_pressed() -> void:
	get_tree().change_scene_to_file("res://opening/train.tscn")


func _on_wake_up_btn_pressed() -> void:
	$ceiling.queue_free()
