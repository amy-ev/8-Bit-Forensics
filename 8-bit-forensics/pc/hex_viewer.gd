extends Control

@export var page:int
@export var search_open:bool = false
@export var select_open:bool = false
@export var hex_data:Array = []

@onready var search_window = preload("res://pc/search.tscn")
@onready var select_window = preload("res://pc/select.tscn")

const VIS_ROWS:int = 18
const TOTAL_ROWS:int = 53

var hex_table:Array = []
var prev_value: int = 0

func _ready():
	# will be changed to match the selected file -- file naming to match JSON file = only has to be created once
	var hex_file = FileAccess.get_file_as_bytes("res://jpg_folder/photo0.jpg")
	if hex_file:
		var arr_str = hex_file.hex_encode()
		for x in range(0, arr_str.length(),2):
			hex_data.append(arr_str.substr(x,2))
			
		for y in range(0,hex_data.size(),16):
			hex_table.append(hex_data.slice(y,y+16))
			
	show_page(0)
	var scroll_bar = $window/label.get_v_scroll_bar()
	scroll_bar.value_changed.connect(_on_scroll_changed)
	test()

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
			
	$window/label.text = display
	
func _on_scroll_changed(value:float):
	var max_scroll:int = TOTAL_ROWS - VIS_ROWS
	print("prev: ", prev_value, "current: ", value)
	print(page)

	if page != 0:
		if value == 0 && (prev_value >= 0 && prev_value <= 10):
			page-=1
			show_page(page)
			print("top of page")
			$window/label.set_v_scroll(max_scroll)
			
	if page != (hex_table.size()/TOTAL_ROWS):
		if value >= max_scroll && (prev_value >= 30):
			print("end of page")
			page+=1
			show_page(page)
		
	prev_value = value	

# opening other windows
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("find"):
		print(search_open)
		if search_open == false && select_open == false:
			search_open = true
			add_child(search_window.instantiate())
			
	if event.is_action_pressed("select_block"):
		print(select_open)
		if select_open == false && search_open == false:
			select_open = true
			add_child(select_window.instantiate())


func test():
	var count:int
	var signature = "ff d8 ff"
	var row:int
	var column:int
	var search_str = []
	var indicies = []
	
	# formatting string 
	signature = signature.replace(" ", "")
	signature = signature.strip_escapes()
	signature = signature.to_lower()

	#if signature.length() >= 2:
		#for i in range(0,signature.length(),2):
			#search_str += signature.substr(i,2) + "\t" + " "
	#else:
		#print("no")
		#search_str = signature

	for i in range(0,signature.length(),2):
		search_str.append(signature.substr(i,2))
	print(search_str)

	for i in range(hex_table.size()):
		for j in range(hex_table[i].size() - search_str.size() +1):
			var matches = true
			for k in range(search_str.size()):
				if hex_table[i][j+k] != search_str[k]:
					matches = false
					break
			if matches:
				print("row %d,column %d" % [i,j])
