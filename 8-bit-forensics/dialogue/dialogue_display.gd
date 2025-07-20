extends CanvasLayer


func _on_button_pressed() -> void:
	if get_parent().has_node("button"):
		get_parent().get_node("button").set_pressed(false)
		queue_free()
	if get_parent().name == "new_bag":
		get_tree().change_scene_to_file("res://end_quiz.tscn")

func start(dialogue:String):
	$panel/dialogue_label.start(dialogue)
