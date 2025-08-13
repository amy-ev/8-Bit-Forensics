extends CanvasLayer


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_cancel_pressed() -> void:
	queue_free()
