extends CanvasLayer


func _ready() -> void:
	Global.connect("text_finished", _on_text_finished)


func start(dialogue:String):
	$panel/dialogue_label.start(dialogue)
	$animation.play("talk")

func _on_ok_pressed() -> void:
	queue_free()

func _on_text_finished():
	$animation.stop()
