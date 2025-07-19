extends CanvasLayer

func start(dialogue:String):
	$panel/dialogue_label.start(dialogue)

func _on_ok_pressed() -> void:
	queue_free()
