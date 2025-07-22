extends NinePatchRect

@onready var hex_viewer = get_parent()

var result = []

func _ready() -> void:
	$start.grab_focus()

func _on_ok_pressed() -> void:
	hex_viewer.select_open = false

	var hex_section = _select($start.text,$end.text)
	
	var output_label = RichTextLabel.new()
	output_label.name = "new file"
	get_parent().get_node("sort/tab").add_child(output_label, true)
	
	var output = get_parent().get_node("sort/tab/"+ output_label.name)
	get_parent().get_node("sort/tab").set_current_tab(get_parent().get_node("sort/tab").get_child_count() -1)
	
	output.custom_minimum_size.x = 192
	output.custom_minimum_size.y = 84
	output.clear()
	
	for i in range(0,hex_section.size(),16):
		result.append(hex_section.slice(i, i + 16))
	for i in range(result.size()):
		var row = result[i]
		for j in range(row.size()):
			output.add_text(str(row[j]))
			if j < row.size() - 1:
				output.add_text(" ")
		output.newline()
	hex_viewer.output = result
	queue_free()

func _select(start_offset, end_offset):
	if (start_offset == null or start_offset == "") or (end_offset == null or end_offset == ""):
		return
		
	var x1 = _hex_to_dec(start_offset)[0]
	var y1 = _hex_to_dec(start_offset)[1]
	var x2 = _hex_to_dec(end_offset)[0]
	var y2 = _hex_to_dec(end_offset)[1]
	
	var start = (x1 * 16) + y1
	var end = (x2 * 16) + y2
	
	var hex_text = hex_viewer.get_node("sort/tab/new file")
	print(x1," ", y1, " ", x2, " ", y2)
	print(start, " ", end)
	return hex_viewer.hex_data.slice(start,end+1)
	
func _hex_to_dec(input:String):
	var x = []
	var y = []
	
	var x_result:int
	var y_result:int
	
	#row
	var row = input.substr(0,input.length()-1)
	row = row.lstrip('0')
	for char in row:
		x.insert(0,char)
	
	for i in range(x.size()):
		x[i] = convert_hex(x[i])
		x_result += int(x[i]) * (16 ** i)

	#column
	var column = input.substr(input.length()-1)
	y.append(column)
	
	for i in range(y.size()):
		y[i] = convert_hex(y[i])
		y_result += int(y[i]) * (16 ** i)
		
	return [x_result, y_result]

func convert_hex(i:String):
	i = i.to_upper()
	match i:
		"A":
			return "10"
		"B":
			return "11"	
		"C":
			return "12"
		"D":
			return "13"
		"E":
			return "14"
		"F":
			return "15"
		_:
			return i

func _on_cancel_pressed() -> void:
	hex_viewer.select_open = false
	queue_free()

func _on_exit_pressed() -> void:
	hex_viewer.select_open = false
	queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close") and hex_viewer.select_open:
		hex_viewer.select_open = false
		queue_free()
