extends NinePatchRect

@onready var hex_viewer = get_parent()
@onready var hex_labels = preload("res://hex_viewer/hex_label.tscn")

var results = []

func _ready() -> void:
	$user_input.grab_focus()

func signature_search(signature:String):
	var search_str:Array = []
	var indicies:Array = []
	
	# formatting string 
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_upper()

	if signature == null or signature == "":
		return
		
	for i in range(0,signature.length(),2):
		search_str.append(signature.substr(i,2))
	print(search_str)

	var row_lengths:Array = [] 
	var row_start_indicies:Array = []
	var total:int = 0
	
	for r in hex_viewer.hex_table:
		row_lengths.append(r.size())
		
	#would all be 16 except for the last row
	for l in row_lengths:
		row_start_indicies.append(total)
		total+= l
	
	print("hex_data size: %d, search_str size: %d" % [hex_viewer.hex_data.size(), search_str.size()+1])
	var found_location=0
	# checking up until where the full search_str can still be read
	for i in range(hex_viewer.hex_data.size() - search_str.size() + 1):
		found_location = i
		var found = true
		for j in range(search_str.size()):
			if hex_viewer.hex_data[i+j] != search_str[j]:
				found = false
				break # otherwise the bool is still true and continues
				
		if found:
			var hex_data_index = i
			var row:int = 0
			while row < row_start_indicies.size()-1 and hex_data_index >= row_lengths[row]:
				hex_data_index -= row_lengths[row]
				row +=1
			var column = hex_data_index
			results.append([row,column])

	if results.size() > 0:
		hex_viewer.get_node("sort/tab/label").scroll_to_line(results[0][0])
		#hex_viewer.get_node("tab/scroll/label").scroll_to_line(results[results.size()-1][0])
	return results

	
	
func _dec_to_hex(x:int, y:int)-> String:
	var result = []
	#row
	while x != 0:
		var r = x % 16
		x = int(x / 16)
		result.insert(0,str(r))
		
	#column
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
	
func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_ok_pressed() -> void:
	var children = []
	
	for i in hex_viewer.get_node("sort/results/offset").get_child_count():
		children.append(hex_viewer.get_node("sort/results/offset").get_child(i))
		
	for child in children:
		child.queue_free()
		
	var hex_arr = signature_search($user_input.text)
	if hex_arr != null:
		for i in hex_arr.size():
			var label = hex_labels.instantiate()
			label.text = _dec_to_hex(hex_arr[i][0], hex_arr[i][1])
			label.theme = load("res://pc_components.tres")
			hex_viewer.get_node("sort/results/offset").add_child(label)
			#prevent it seeming like a crash has occured when searching common hex
			await get_tree().process_frame
			
			print(_dec_to_hex(hex_arr[i][0], hex_arr[i][1]))
	hex_viewer.search_open = false
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close") and hex_viewer.search_open:
		hex_viewer.search_open = false
		queue_free()
		
