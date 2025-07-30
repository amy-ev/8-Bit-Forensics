extends NinePatchRect

@onready var hex_viewer = get_parent()
@onready var results_viewer = get_parent().get_node("v_sort/results_scroll_manager")
var results = []

func _ready() -> void:
	$user_input.grab_focus()
	results_viewer.results_text.results_recieved = false
	results_viewer.results_text.queue_redraw()
	
func _search(signature:String):
	
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_lower()

	if signature == null or signature == "":
		return
		
	var buffer:= PackedByteArray()

	if hex_viewer.tabs.current_tab != 0:
		buffer = hex_viewer._wrapped_buffer.buffer
		#buffer = hex_viewer.hex_text._wrapped_buffer
	else:
		buffer = hex_viewer._wrapped_buffer.buffer
		#buffer = hex_viewer.hex_text._wrapped_buffer.buffer
	#
	var search_arr = []
	
	for i in range(0,signature.length(),2):
		search_arr.append(signature.substr(i,2))
	var found_location = 0
	
	for i in range(hex_viewer.buffer_len - len(search_arr)+1):
		print("kill me ", i )
		await get_tree().create_timer(0.01).timeout
		
		
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
			results.append([_dec_to_hex(row,column), hex_index])
	print(results)
	return results
	
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
	if $user_input.text != "":
		var results_buffer = _search_v2(hex_viewer._wrapped_buffer.buffer,$user_input.text)
		#var results_buffer = await _search($user_input.text)
		if results_buffer != null:
			Global.emit_signal("signature_found", results)
			results_viewer.results_text.update_scroll(results_buffer)
			results_viewer.scroll_bar.update_scroll(results_buffer)
	#
	hex_viewer.search_open = false
	queue_free()

func _search_v2(original_buffer, signature, chunk_size=4096):
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_lower()

	if signature == null or signature == "":
		return
	
	#not ideal but it takes too long to search through the entire 1gb file
	# value comes from forensic imaging 
	var unpartionted_space:= 1983936
	
	var signature_bytes = PackedByteArray()

	for i in range(0,signature.length(),2):
		signature_bytes.append(signature.substr(i,2).hex_to_int())
		
	var signature_len = len(signature_bytes)
	
	var buffer:= PackedByteArray()
	var offset:= 0
	#to get the right offset
	var overlap:= PackedByteArray()
	
	while offset < unpartionted_space:
		var end = min(offset+chunk_size, unpartionted_space)
		var chunk = original_buffer.slice(offset,end)
		
		if not chunk:
			break
			
		buffer = overlap + chunk
		
		var search_pos = 0
		while search_pos <= len(buffer) - signature_len:
			if buffer.slice(search_pos, search_pos + signature_len) == signature_bytes:
				var signature_location = offset - len(overlap) + search_pos
				
				#print("offset: %08x" % signature_location)
				#print(signature_location)
				results.append(["%08x"%signature_location, signature_location])
			search_pos += 1

		overlap = buffer.slice(max(len(buffer) - (signature_len - 1),0))

		offset += len(chunk)
	return results
	
