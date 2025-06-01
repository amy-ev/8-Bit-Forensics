extends Control

var hex_table:Array = []
var hex_data:Array = []
var page:int
var prev_value: int = 0

const VIS_ROWS:int = 18
const TOTAL_ROWS:int = 53

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

func show_page(p:int):
	page = p
	var display := ""
	var start = page * TOTAL_ROWS
	var end = min(start + TOTAL_ROWS, hex_table.size())
	print(hex_table.size()/TOTAL_ROWS)

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
	var max_scroll:int = TOTAL_ROWS - VIS_ROWS
	print("prev: ", prev_value, "current: ", value)
	print(page)

	if page != 0:
		if value == 0 && (prev_value >= 0 && prev_value <= 10):
			page-=1
			show_page(page)
			print("top of page")
			$label.set_v_scroll(max_scroll)
			
	if page != (hex_table.size()/TOTAL_ROWS):
		if value >= max_scroll && (!prev_value <= 10):
			print("end of page")
			page+=1
			show_page(page)
		
	prev_value = value	
	
func signature_search(signature:String):
	print(signature)
	
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_lower()
	
	print(signature)
	var result = $label.search(signature,0, 0 ,0)
