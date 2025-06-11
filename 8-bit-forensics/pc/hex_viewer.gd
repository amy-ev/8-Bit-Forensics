extends Control

@export var page:int

@export var search_open:bool = false
@export var select_open:bool = false
@export var hex_data:Array = []

@onready var search_window = preload("res://pc/search.tscn")
@onready var select_window = preload("res://pc/select.tscn")
@onready var hex_label = $window/label

const VIS_ROWS:int = 22
const PAGE_ROWS:int = 53

var TOTAL_ROWS:int
var hex_table:Array = []

func _ready():
	# will be changed to match the selected file -- file naming to match JSON file = only has to be created once
	var hex_file = FileAccess.get_file_as_bytes("res://jpg_folder/photo0.jpg")
	if hex_file:
		var arr_str = hex_file.hex_encode()
		for x in range(0, arr_str.length(),2):
			hex_data.append(arr_str.substr(x,2))
			
		for y in range(0,hex_data.size(),16):
			hex_table.append(hex_data.slice(y,y+16))
			
	hex_label.set_threaded(true)
	
	TOTAL_ROWS = hex_table.size()/PAGE_ROWS
	hex_label.custom_minimum_size.y = 505
	show_page(0)

func _process(delta: float) -> void:
	while page != TOTAL_ROWS:
		page += 1
		show_page(page)
		
func show_page(p:int):
	page = p
	var start = page * PAGE_ROWS
	var end = min(start + PAGE_ROWS, hex_table.size())
	
	for i in range(start, end):
		var row = hex_table[i]
		
		for j in range(row.size()):
			hex_label.add_text(str(row[j]))
			
			if j < row.size() - 1:
				hex_label.add_text(" ")

		hex_label.add_text("\n")
		
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
