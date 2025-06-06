extends Control

@onready var hex_viewer = get_parent()

func _on_exit_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_cancel_pressed() -> void:
	hex_viewer.search_open = false
	queue_free()
	
func _on_ok_pressed() -> void:
	signature_search($window/user_input.text)
	hex_viewer.search_open = false
	queue_free()
	
func signature_search(signature:String) -> Array:
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

		return [row,column]
		
	else:
		print("not found")
		return []
