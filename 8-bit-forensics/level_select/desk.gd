extends TextureRect

@export var scaled_by: Vector2
var fullscreen:bool = false

func _ready() -> void:
	update_size()
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()


func update_size():
	var original_size = size

	size = DisplayServer.window_get_size()
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	var tabs
	
	if has_node("closed_folder/tabs"):
		tabs = $closed_folder/tabs
	elif has_node("level_select_1"):
		tabs = $level_select_1/tabs
	elif has_node("level_select_2"):
		tabs = $level_select_2/tabs
	elif has_node("level_select_3"):
		tabs = $level_select_3/tabs
	elif has_node("level_select_4"):
		tabs = $level_select_4/tabs	
		
	if tabs:
		for tab in range(tabs.get_children().size()):
			tabs.get_child(tab).set_scale(tabs.get_child(tab).scale / scaled_by)
			tabs.get_child(tab).position = tabs.get_child(tab).position / scaled_by
			
			print("scale: %v, position: %v at size: %v" % [tabs.get_child(tab).scale,tabs.get_child(tab).position, size])
		

#TODO: This will be added to the main node of the game, allowing for resizing at any point
func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false


func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu/menu.tscn")
