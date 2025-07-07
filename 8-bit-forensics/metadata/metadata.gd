extends NinePatchRect

@onready var _file_dialogue = preload("res://file_dialog/load_file.tscn")
var keys_and_values = []

var current_rect: ColorRect

func _ready() -> void:
	Global.connect("metadata_selected", _on_label_selected)
func _on_select_pressed() -> void:
	var file_dialogue = _file_dialogue.instantiate()
	add_child(file_dialogue)

	await file_dialogue.tree_exited
	for hbox in $scroll/data_container.get_children():
		keys_and_values.append(hbox)
	print("its gone")
	
func _on_exit_pressed() -> void:
	queue_free()
	


func _process(delta: float) -> void:
	if $backgrounds.minimum_size_changed:
		$backgrounds.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - 135
	if $backgrounds/value_background.minimum_size_changed:
		$backgrounds/value_background.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - (135 + $"backgrounds/key_background".custom_minimum_size.x)
	if $scroll.minimum_size_changed:
		$scroll.custom_minimum_size.x = $backgrounds.custom_minimum_size.x - 6
		$scroll/data_container.custom_minimum_size.x = $scroll.custom_minimum_size.x - 8
	if !keys_and_values.is_empty():
		
		for hbox in keys_and_values.size():
			if keys_and_values[hbox].minimum_size_changed:
				keys_and_values[hbox].get_child(0).custom_minimum_size.x = $backgrounds/key_background.custom_minimum_size.x - 3
				keys_and_values[hbox].get_child(0).get_node("selected").custom_minimum_size.x = ($backgrounds/key_background.custom_minimum_size.x + $backgrounds/value_background.custom_minimum_size.x)
				keys_and_values[hbox].get_child(0).get_node("select/select_shape").shape.size.x = ($backgrounds/key_background.custom_minimum_size.x + $backgrounds/value_background.custom_minimum_size.x)
				keys_and_values[hbox].get_child(1).custom_minimum_size.x = $backgrounds/value_background.custom_minimum_size.x - 3
			#keys_and_values[hbox].custom_minimum_size.x = $scroll/data_container.custom_minimum_size.x

	#$scroll/data_container/keys.custom_minimum_size.x = $backgrounds/key_background.custom_minimum_size.x
	#$scroll/data_container/values.custom_minimum_size.x = $backgrounds/value_background.custom_minimum_size.x
func _on_label_selected(selected:Node):
	var selected_rect = selected.get_node("selected")
	
	# if current_rect is not null and current_rect is not from the label just emitted
	if current_rect and current_rect != selected_rect:
		current_rect.visible = false

	selected_rect.visible = true
	current_rect = selected_rect
	print(selected.text)
