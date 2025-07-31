extends ColorRect

@onready var pc = get_parent()

func _ready() -> void:
	if get_parent().has_node("dialogue_display"):
		get_parent().remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	get_parent().add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e5.3")
	
	Global.emit_signal("next_step",self)

func _on_back_pressed() -> void:
	pc.add_child(load("res://evidence/image_type.tscn").instantiate())
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_next_pressed() -> void:

	if $window/sort/examiner.text == Global.form_name:
		pc.add_child(preload("res://evidence/create_file.tscn").instantiate())
		queue_free()
	else:
		Global.emit_signal("answer_response",false)
