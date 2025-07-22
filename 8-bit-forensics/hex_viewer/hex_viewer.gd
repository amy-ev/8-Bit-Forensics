extends NinePatchRect

@export var page:int

var load_file_open:bool = false
@export var search_open:bool = false
@export var select_open:bool = false
@export var hex_data:PackedStringArray

@onready var search_window = preload("res://hex_viewer/search.tscn")
@onready var select_window = preload("res://hex_viewer/select.tscn")
@onready var hex_label = $sort/tab/label

const PAGE_ROWS:int = 2000
var TOTAL_ROWS:int
var hex_table:Array

var output = []
var thread:Thread
var mutex:Mutex

func _ready() -> void:
	hex_label.bbcode_enabled = false
	hex_label.custom_minimum_size.x = 196
	hex_label.custom_minimum_size.y = 96
	Global.connect("hex_selected", _on_hex_select)
	#allow the text to be added by another thread to allow player to still interact
	thread = Thread.new()
	mutex = Mutex.new()
	
func _thread_function():
	while page != TOTAL_ROWS:
		mutex.lock()
		page += 1
		mutex.unlock()
		
		show_page(page)
		#slightly increases process time
		#but ensures lines are placed in the right order
		#add that the file dialogue window closes
		await get_tree().process_frame
	print("thread finished")
	
func open_file(file_path):
	var children = []
	
	for i in $sort/results/offset.get_child_count():
		children.append($sort/results/offset.get_child(i))
		
	for child in children:
		child.queue_free()
		
	$sort/tab/label.scroll_to_line(0)
	$sort/tab/label.clear()
	
	if FileAccess.file_exists(file_path):
		#hex_label.set_visible(false)
		var file = FileAccess.open(file_path, FileAccess.READ)
		var hex_file = file.get_buffer(file.get_length())
		var arr_str = hex_file.hex_encode()
		
		var num_bytes = arr_str.length() / 2
		#faster than appending
		hex_data.resize(num_bytes)
		
		for x in range(num_bytes):
			hex_data[x] = arr_str.substr(x * 2, 2)
		
		hex_table.clear()
		
		for y in range(0,num_bytes,16):
			hex_table.append(PackedStringArray(hex_data.slice(y,y+16)))
	else:
		print("failed to open file")
		return
	
	TOTAL_ROWS = ceili(hex_table.size()/PAGE_ROWS)
	
	show_page(0)
	#to allow for another file to be opened after
	if !thread.is_alive():
		if thread.is_started():
			thread.wait_to_finish()
		thread.start(_thread_function)
	
func _exit_tree() -> void:
	thread.wait_to_finish()
	
func show_page(p:int):
	page = p
	var start = page * PAGE_ROWS
	var end = min(start + PAGE_ROWS, hex_table.size())

	for i in range(start, end):
		var row:= PackedStringArray(hex_table[i])
		
		for j in (row.size()):
			#hex_label.add_text(str(row[j]))
			hex_label.call_deferred("add_text",str(row[j]))
			
			if j < row.size() - 1:
				#hex_label.add_text(" ")
				hex_label.call_deferred("add_text"," ")
				
		#hex_label.newline()
		hex_label.call_deferred("newline",)

# opening other windows
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("find"):
		print(search_open)
		if !search_open && !select_open && !load_file_open:
			search_open = true
			add_child(search_window.instantiate())
			
	if event.is_action_pressed("select_block"):
		print(select_open)
		if !select_open && !search_open && !load_file_open:
			select_open = true
			add_child(select_window.instantiate())

func _on_hex_select(row:int):
	$sort/tab/label.scroll_to_line(row)
	
func _on_exit_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	var file = FileAccess.open("res://jpg_folder/tester.txt", FileAccess.WRITE)
	for i in range(output.size()):
		var line = output[i]
		for j in range(line.size()):
			file.store_string(line[j])
			
	
func _on_open_pressed() -> void:
	if !search_open && !select_open:
		add_child(load("res://file_dialog/load_file.tscn").instantiate())
		load_file_open = true
