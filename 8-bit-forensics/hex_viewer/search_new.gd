extends NinePatchRect

@onready var hex_viewer = get_parent()
var results = []

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
	var found_location = 0
	for i in range(len(buffer) - len(search_arr)+1):
		found_location = i
		var found = true
		for j in range(search_arr.size()):
			if hex_viewer.hex_text._hex_to_string[buffer[i+j]] != search_arr[j]:
				found = false
				break
		if found:
			var hex_index = i
			var row = hex_index / 16
			var column = hex_index % 16
			results.append(_dec_to_hex(row,column))
		
	
	
func _dec_to_hex(x:int, y:int)-> String:
	var result = []

	while x != 0:
		var r = x % 16
		x = int(x / 16)
		result.insert(0,str(r))
		
	while y != 0:
		var r = y % 16
		y = int(y / 16)
		result.append(str(r))
	
	for i in range(result.size()):
		if result[i] == "10":
			result[i] = "A"
		if result[i] == "11":
			result[i] = "B"
		if result[i] == "12":
			result[i] = "C"
		if result[i] == "13":
			result[i] = "D"
		if result[i] == "14":
			result[i] = "E"
		if result[i] == "15":
			result[i] = "F"
			
	var hex = ''.join(result)
	var left_padding = 8 - hex.length()
	
	if left_padding > 0:
		return "0".repeat(left_padding) + hex
	return hex
	
func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()

func _on_ok_pressed() -> void:
	_search($user_input.text)
	Global.emit_signal("signature_found", results)
	
	hex_viewer.search_open = false
	queue_free()
