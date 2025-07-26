extends VBoxContainer

@onready var pc = get_parent()

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$case_no.grab_focus()
	
func _on_back_pressed() -> void:
	pc.add_child(load("res://evidence/image_type.tscn").instantiate())
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_next_pressed() -> void:

	if $examiner.text == Global.form_name:
		pc.add_child(load("res://evidence/create_file.tscn").instantiate())
		queue_free()
	else:
		Global.emit_signal("answer_response",false)
