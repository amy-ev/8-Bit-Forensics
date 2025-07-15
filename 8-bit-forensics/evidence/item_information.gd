extends VBoxContainer

func _ready() -> void:
	$case_no.grab_focus()
func _on_back_pressed() -> void:
	get_parent().add_child(load("res://evidence/image_type.tscn").instantiate())
	queue_free()
	
func _on_finish_pressed() -> void:
	get_parent().add_child(load("res://evidence/create_file.tscn").instantiate())
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()
