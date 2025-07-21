extends ColorRect

var pc_screen = preload("res://pc/pc_screen.tscn")

func _on_on_button_pressed() -> void:
	var pc = pc_screen.instantiate()
	add_child(pc)
