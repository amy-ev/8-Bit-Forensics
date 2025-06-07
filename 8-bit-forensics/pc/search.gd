extends Control

@onready var hex_viewer = get_parent()

func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_ok_pressed() -> void:
	print(signature_search($window/user_input.text))
	hex_viewer.search_open = false
	queue_free()
	
func signature_search(signature:String) -> String:
	var row:int
	var column:int
	var search_str:String
	
	# formatting string 
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_lower()

	if signature.length() >= 2:
		for i in range(0,signature.length(),2):
			search_str += signature.substr(i,2) + "\t" + " "
	else:
		print("no")
		# TODO: REPLACE WITH ERROR HANDLING 
		search_str = signature
		
	var hex_text = hex_viewer.get_node("window/label")
	
	var result = hex_text.search(search_str,0 , 0 ,0)
	if result != Vector2i(-1,-1):
		column = result[0]/4
		row = result[1]
		
		var max_scroll = 32
		if result[1] > 30:
			hex_text.set_v_scroll((result[1]-hex_viewer.VIS_ROWS)+1)
		else:
			hex_text.set_v_scroll(result[1])
			
		if hex_viewer.page > 0:
			row = result[1]+(hex_viewer.page*hex_viewer.TOTAL_ROWS)
		print([row,column])
		return _dec_to_hex(row,column)
		
	else:
		print("not found")
		return ""

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
