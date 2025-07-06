extends NinePatchRect

@onready var file_dialogue = preload("res://file_dialog/load_file.tscn")

func _on_select_pressed() -> void:
	add_child(file_dialogue.instantiate())

func _on_exit_pressed() -> void:
	queue_free()


func _process(delta: float) -> void:
	$backgrounds.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - 135
	$backgrounds/value_background.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - (135 + $"backgrounds/key_background".custom_minimum_size.x)
	
	$scroll/data_container/key.custom_minimum_size.x = $backgrounds/key_background.custom_minimum_size.x
	$scroll/data_container/value.custom_minimum_size.x = $backgrounds/value_background.custom_minimum_size.x
