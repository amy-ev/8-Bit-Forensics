extends NinePatchRect

@onready var file_dialogue = preload("res://file_dialog/load_file.tscn")

func _on_select_pressed() -> void:
	add_child(file_dialogue.instantiate())
