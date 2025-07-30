extends NinePatchRect

@onready var hex_viewer = get_parent()
@onready var _new_file = preload("res://hex_viewer/new_file.tscn")

var block_carved:bool
var carved_buffer:=PackedByteArray()

func _ready() -> void:
	block_carved = false
	$start.grab_focus()
	
func _select(start,end):
	var buffer = hex_viewer._wrapped_buffer.buffer
	
	start = _hex_to_dec(start)
	end = _hex_to_dec(end)
	
	var carved_block:=PackedByteArray()
	for i in range(start,end+1):
		carved_block.append(buffer[i])
	return carved_block

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
	
	var hex_index:int
	
	if x_result == 0:
		hex_index = x_result + y_result
	else:
		hex_index = (x_result) * 16
		hex_index += y_result
	return hex_index
	
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
			
func _on_ok_pressed() -> void:
	hex_viewer.select_open = false
	if $start.text != "" && $end.text != "":
		carved_buffer = _select($start.text, $end.text)
		if carved_buffer != null:
			block_carved = true
			var new_file = _new_file.instantiate()
			new_file.name = "new_file1"
			hex_viewer.get_node("v_sort/scroll_manager/sort/window").add_child(new_file, true)
			
			new_file.get_node("hex_text").set_wrapped_buffer(carved_buffer)
			hex_viewer.get_node("v_sort/scroll_manager").scroll_bar.update_scroll(carved_buffer)
			new_file.get_node("hex_text").update_scroll(carved_buffer)
			
			new_file.get_node("hex_text").carved_block = carved_buffer
			hex_viewer.get_node("v_sort/scroll_manager/sort/window").set_current_tab(hex_viewer.get_node("v_sort/scroll_manager/sort/window").get_child_count() -1)
			hex_viewer.get_node("save").disabled = false
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
