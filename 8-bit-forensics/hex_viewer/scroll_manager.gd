extends HBoxContainer

@onready var hex_text = $sort/window/original_file/hex_text
@onready var scroll_bar = $scroll_bar

var _last_scroll_time = 0

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				_scroll(int(event.factor))
			MOUSE_BUTTON_WHEEL_UP:
				_scroll(-int(event.factor))
				
func _scroll(delta):
	if get_node("sort/window").current_tab != 0:
		hex_text = get_node("sort/window/new_file"+str(get_node("sort/window").current_tab)+"/hex_text")
	else:
		hex_text = $sort/window/original_file/hex_text
	var now = Time.get_ticks_msec()
	
	if Input.is_key_pressed(KEY_CTRL):
		var row_count = hex_text.get_visible_row_count()
		if delta <0:
			delta = -row_count
		else:
			delta = row_count
	elif now - _last_scroll_time < 20:
		delta *= 3
	elif now - _last_scroll_time < 50:
		delta *= 2
	_last_scroll_time = Time.get_ticks_msec()
	
	_scroll_to(hex_text.get_row_index() + delta)
	
func _scroll_to(i):
	if i < 0:
		i = 0
	hex_text.set_row_index(i)
	scroll_bar.set_row_index(i)
	
func _on_scroll_bar_ask_scroll(row_index):
	_scroll_to(row_index)
