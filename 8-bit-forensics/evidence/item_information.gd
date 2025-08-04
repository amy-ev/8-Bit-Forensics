extends ColorRect

@onready var screen = get_parent()

func _ready() -> void:
	Global.emit_signal("dialogue_triggered","e5.3")
	Global.emit_signal("next_step",self)

func _on_back_pressed() -> void:
	screen.add_child(load("res://evidence/image_type.tscn").instantiate())
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_next_pressed() -> void:

	if $window/sort/examiner.text == Global.form_name:
		screen.add_child(preload("res://evidence/create_file.tscn").instantiate())
		queue_free()
	else:
		Global.emit_signal("answer_response",false)
