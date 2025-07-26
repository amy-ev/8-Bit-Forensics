extends CanvasLayer


func _ready() -> void:
	Global.connect("answer_response", _on_option_confirmed)
	
func start(dialogue:String):
	set_visible(true)
	$panel/dialogue_label.start(dialogue)
	$animation.play("talk")
	
func _on_dialogue_label_text_finished() -> void:
	$animation.stop()

func _on_option_confirmed(is_correct:bool):
	if is_correct:
		start("correct!")
	else:
		start("wrong")

func _on_confirm_pressed() -> void:
	set_visible(false)
