extends VBoxContainer

@onready var _dialogue = preload("res://dialogue/redirect_dialogue.tscn")

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$case_no.grab_focus()
	
func _on_back_pressed() -> void:
	get_parent().add_child(load("res://evidence/image_type.tscn").instantiate())
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_next_pressed() -> void:
	if $examiner.text == Global.form_name:
		get_parent().add_child(load("res://evidence/create_file.tscn").instantiate())
		queue_free()
	else:
		var dialogue = _dialogue.instantiate()
		add_child(dialogue)
		dialogue.start("needs to match!")
