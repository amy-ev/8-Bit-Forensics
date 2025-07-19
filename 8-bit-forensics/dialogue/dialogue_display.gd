extends CanvasLayer


func _on_button_pressed() -> void:
	get_parent().get_node("button").set_pressed(false)
	queue_free()

func start(dialogue:String):
	$panel/dialogue_label.start(dialogue)
