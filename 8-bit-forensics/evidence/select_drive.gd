extends VBoxContainer

var is_correct:bool

func _on_back_pressed() -> void:
	get_parent().add_child(load("res://evidence/select_source.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	if is_correct:
		get_parent().add_child(load("res://evidence/image_type.tscn").instantiate())
		queue_free()
	else:
		print("nope try again")
		
func _on_cancel_pressed() -> void:
	queue_free()

func _on_options_item_selected(index: int) -> void:
	match index:
		0:
			print("nope")
		1:
			print("nope")
		2:
			print("correct")
			
	if index == 2:
		is_correct = true
	else:
		is_correct = false
