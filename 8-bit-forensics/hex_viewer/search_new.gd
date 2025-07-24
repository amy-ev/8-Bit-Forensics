extends NinePatchRect

@onready var hex_viewer = get_parent()

func _ready() -> void:
	$user_input.grab_focus()
	
	
func _search(signature:String):
	var buffer:= PackedByteArray()
	
	if hex_viewer.tabs.current_tab != 0:
		buffer = hex_viewer.hex_text._wrapped_buffer
	else:
		buffer = hex_viewer.hex_text._wrapped_buffer.buffer
	var search_arr = []
	
	for i in range(0,signature.length(),2):
		search_arr.append(signature.substr(i,2))
	print(search_arr)
	
	var found_location = 0
	for i in range(len(buffer) - len(search_arr)+1):
		found_location = i
		var found = true
		for j in range(search_arr.size()):
			print(hex_viewer.hex_text._hex_to_string[buffer[i+j]])
			print(search_arr[j])
			if hex_viewer.hex_text._hex_to_string[buffer[i+j]] != search_arr[j]:
				found = false
				break
		if found:
			var hex_index = i
	
	
func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()

func _on_ok_pressed() -> void:
	_search($user_input.text)
	hex_viewer.search_open = false
	queue_free()
