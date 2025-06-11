extends Control

@onready var hex_viewer = get_parent()

func _on_ok_pressed() -> void:
	hex_viewer.select_open = false
	#_select($window/start.text,$window/end.text)
	_hex_to_dec($window/start.text)
	queue_free()

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

func _ready() -> void:
	$window/start.grab_focus()

func _select(start_offset, end_offset):
	var x1 = int(start_offset.substr(0,2))
	var y1 = int(start_offset.substr(2,-1))
	
	var x2 = int(end_offset.substr(0,2))
	var y2 = int(end_offset.substr(2,-1))
	
	var start = (x1 * 16) + y1
	var end = (x2 * 16) + y2
	
	var hex_text = hex_viewer.get_node("window/label")
	print(x1," ", y1, " ", x2, " ", y2)
	print(start, " ", end)
	#return hex_text.hex_data.slice(start,end+1)
	
	
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
	if i == "A":
		return "10"
	if i == "B":
		return "11"
	if i == "C":
		return "12"
	if i == "D":
		return "13"
	if i == "E":
		return "14"
	if i == "F":
		return "15"
	else:
		return i
