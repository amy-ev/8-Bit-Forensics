extends Control

var resize = false
var start_pos: Vector2
var start_width:int

@onready var key_panel = $"../key_background"
@onready var value_panel = $"../value_background"

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				resize = true
				start_pos = event.position
				start_width = key_panel.size.x
			else:
				resize = false
	elif event is InputEventMouseMotion and resize:
		var delta = event.position.x - start_pos.x
		var new_width = clamp(start_width + delta, 123, ($"..".custom_minimum_size.x - size.x)) #(get_tree().current_scene.get_node("metadata_window").custom_minimum_size.x)-135)

		key_panel.custom_minimum_size.x = new_width
		
