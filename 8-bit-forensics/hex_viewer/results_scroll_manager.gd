extends HBoxContainer

@onready var results_text = $results
@onready var scroll_bar = $results_scroll_bar

var _last_scroll_time = 0

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				_scroll(int(event.factor))
			MOUSE_BUTTON_WHEEL_UP:
				_scroll(-int(event.factor))
				
func _scroll(delta):
	var now = Time.get_ticks_msec()
	if Input.is_key_pressed(KEY_CTRL):
		var row_count = results_text.get_visible_row_count()
		if delta <0:
			delta = -row_count
		else:
			delta = row_count
	elif now - _last_scroll_time < 20:
		delta *= 3
	elif now - _last_scroll_time < 50:
		delta *= 2
	_last_scroll_time = Time.get_ticks_msec()
	
	_scroll_to(results_text.get_row_index() + delta)
	
func _scroll_to(i):
	if i < 0:
		i = 0
	results_text.set_row_index(i)
	scroll_bar.set_row_index(i)

func _on_results_scroll_bar_ask_scroll(row_index):
	_scroll_to(row_index)
