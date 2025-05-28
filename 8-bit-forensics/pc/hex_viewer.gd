extends Control

var hex_table:Array = []
var hex_data:Array = []
var page:int = 0
var prev_value: int = 0

const VIS_ROWS:int = 53

func _ready():
	
	var hex_file = FileAccess.get_file_as_bytes("res://jpg_folder/photo0.jpg")
	if hex_file:
		var arr_str = hex_file.hex_encode()
		for x in range(0, arr_str.length(),2):
			hex_data.append(arr_str.substr(x,2))
			
		for y in range(0,hex_data.size(),16):
			hex_table.append(hex_data.slice(y,y+16))
			
	var scroll_bar = $label.get_v_scroll_bar()
	scroll_bar.value_changed.connect(_on_scroll_changed)
	show_page(0)

func show_page(page):
	
	var display := ""
	var start = page * VIS_ROWS
	var end = min(start + VIS_ROWS, hex_table.size())

	for i in range(start, end):
		var row = hex_table[i]
		for j in range(row.size()):
			display+= str(row[j]) + "\t" # change to monospace font and columns should be even
			if j < row.size() -1:
				display += " "
		if i < end - 1:
			display += "\n"
			
	$label.text = display
	
func _on_scroll_changed(value:float):
	var max_scroll:int = $label.get_content_height() - $label.size.y
	print("prev: ", prev_value, "current: ", value)
	print(page)
	
	if page != 0:
		if value == 0 && (prev_value >= 0 && prev_value <= 100):
			show_page(page - 1)
			$label.scroll_to_line($label.get_line_count()-1)
			
	if page != (hex_table.size()/VIS_ROWS):
		if value >= max_scroll && (!prev_value <= 100):
			show_page(page + 1)
			$label.scroll_to_line(0)
		
	prev_value = value	
