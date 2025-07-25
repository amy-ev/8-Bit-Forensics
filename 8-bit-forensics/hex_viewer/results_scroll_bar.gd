extends ColorRect

signal ask_scroll(_row_index)

var _row_index = 0
var row_width = 16
var total_rows = 0

#no. of rows on screen - 1 
var OFFSET:= 2

func update_scroll(buffer):
	total_rows = len(buffer) / row_width
	_row_index = clamp(_row_index,0, max(total_rows - OFFSET,0))

func set_row_index(i):
	var visible_rows = int(size.y)
	var max_index = max(total_rows - OFFSET ,0)
	i = clamp(i,0,max_index)
	
	if _row_index != i:
		_row_index = i
		queue_redraw()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#any mouse button
		if (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			var mouse_pos = event.position
			var row_index = _get_row_index(mouse_pos.y)
			emit_signal("ask_scroll", row_index)

func _get_row_index(offset):
	if total_rows <= size.y:
		return int(offset)
			
	var row_index = int(total_rows * (offset / size.y))
	return clamp(row_index,0, total_rows - OFFSET)
