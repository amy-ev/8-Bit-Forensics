extends Control

@onready var hex_viewer = get_parent()

func _on_ok_pressed() -> void:
	hex_viewer.search_open = false
	_select($window/start.text,$window/end.text)
	queue_free()

func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()

func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()

func _select(start_offset, end_offset):
	var x1 = int(start_offset.substr(0,2))
	var y1 = int(start_offset.substr(2,-1))
	
	var x2 = int(end_offset.substr(0,2))
	var y2 = int(end_offset.substr(2,-1))
	
	var start = (x1 * 16) + y1
	var end = (x2 * 16) + y2
	
	var hex_text = hex_viewer.get_node("window/label")
	print(x1," ", y1, " ", x2, " ", y2)
	print(start, " ", end)
	#return hex_text.hex_data.slice(start,end+1)
