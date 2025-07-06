extends Control

var resize = false
var start_pos: Vector2
var start_width:int

@onready var panel = $"../metadata_window"

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				resize = true
				start_pos = event.position
				start_width = panel.size.x
			else:
				resize = false
	elif event is InputEventMouseMotion and resize:
		var delta = event.position.x - start_pos.x
		var new_width = start_width + delta

		panel.custom_minimum_size.x = max(444, new_width)
		
