extends Node

var sizes_fullscreen:Array 
var pos_fullscreen:Array
var shape_fullscreen:Array

var sizes_window:Array
var pos_window:Array
var shape_window:Array

func _ready() -> void:
	Global.connect("child_joined",_on_child_joined)
	
	if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
		Global.fullscreen = false
		create_node_arrays("windowed")
		decrease_measurements()
		
	elif DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
		print("window is fullscreen")
		Global.fullscreen = true
		create_node_arrays("fullscreen")
		increase_measurements()

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action_pressed("fullscreen"):
		print(DisplayServer.window_get_mode(0))
		if !Global.fullscreen:
			increase_measurements()
			create_node_arrays("fullscreen")
			Global.fullscreen = true
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		else:
			decrease_measurements()
			create_node_arrays("windowed")
			Global.fullscreen = false
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _handle_fullscreen(current_node):
	var result = [current_node]
	for node in current_node.get_children():
		result += _handle_fullscreen(node)
	return result

func _on_child_joined() -> void:
	await get_tree().process_frame
	if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
		create_node_arrays("windowed")
		#decrease_measurements()
		
	elif DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
		create_node_arrays("fullscreen")
		#increase_measurements()

func increase_measurements() -> void:
	var items = _handle_fullscreen(self)
	for item in items.size():
		if "size" in items[item]:
			if sizes_fullscreen[item] != items[item].size:
				print("increasing")
				items[item].size *= 1.5
				
		if "position" in items[item]:
			if pos_fullscreen[item] != items[item].position:
				items[item].position *= 1.5
				
		if "shape" in items[item]:
			if "size" in items[item].shape:
					if shape_fullscreen[item] != items[item].shape.size:
						items[item].shape.size *= 1.5
						
						
func decrease_measurements() -> void:
	var items = _handle_fullscreen(self)
	for item in items.size():
		if "size" in items[item]:
			if sizes_window[item] != items[item].size:
				print("decreasing")
				items[item].size /= 1.5
		
		if "position" in items[item]:
			if pos_window[item] != items[item].position:
				items[item].position /= 1.5
				
		if "shape" in items[item]:
			if "size" in items[item].shape:
				if shape_window[item] != items[item].shape.size:
					items[item].shape.size /= 1.5
					
func create_node_arrays(display_mode: String) -> void:
	sizes_fullscreen = []
	pos_fullscreen = []
	shape_fullscreen = []
	
	sizes_window = []
	pos_window = []
	shape_window = []
	
	var items = _handle_fullscreen(self)
	for item in items.size():
		if "size" in items[item]:
			if display_mode == "windowed":
				sizes_fullscreen.append(items[item].size * 1.5)
				sizes_window.append(items[item].size)
			else:
				sizes_fullscreen.append(items[item].size)
				sizes_window.append(items[item].size /1.5)
		else:
			sizes_fullscreen.append(item)
			sizes_window.append(item)

		if "position" in items[item]:
			if display_mode == "windowed":
				pos_fullscreen.append(items[item].position * 1.5)
				pos_window.append(items[item].position)
			else:
				pos_fullscreen.append(items[item].position)
				pos_window.append(items[item].position / 1.5)
		else:
			pos_fullscreen.append(item)
			pos_window.append(item)
			
		if "shape" in items[item]:
			if "size" in items[item].shape:
				if display_mode == "windowed":
					shape_fullscreen.append(items[item].shape.size * 1.5)
					shape_window.append(items[item].shape.size)
				else:
					shape_fullscreen.append(items[item].shape.size)
					shape_window.append(items[item].shape.size / 1.5)
		else:
			shape_fullscreen.append(item)
			shape_window.append(item)


func _on_child_entered_tree(node: Node) -> void:
	await get_tree().process_frame

func _on_child_exiting_tree(node: Node) -> void:
	await get_tree().process_frame
