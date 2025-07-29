extends Control


var font: FontFile

var _wrapped_buffer = null

var results_buffer = []
var locations_buffer = []
var surrounding_hex = []

var row_index:= 0
var _row_width := 16
var char_width := 0
var _total_rows := 0

var offset_gap := 0
var hex_text_gap := 0
var separation := 0

@onready var carved_block:=PackedByteArray()

var results_recieved:bool

var OFFSET:int
var FONT_SIZE:= 8
var FONT_COLOUR:= Color(0.322, 0.282, 0.224)

func _ready() -> void:

	font = preload("res://8-bit-forensics.ttf")
	OFFSET = get_visible_row_count() - 1

	Global.connect("signature_found", _on_results_found)

func _on_results_found(results:Array):
	for i in len(results):
		results_buffer.append(results[i][0])
		locations_buffer.append(results[i][1])
		
	var buffer = _wrapped_buffer.buffer
	var columns = []
	for i in locations_buffer:
		columns.append(i%16)
		
	for i in len(columns):
		if locations_buffer[i]+columns[i] < len(buffer):
			if locations_buffer[i] != 0:
				for j in range(locations_buffer[i] - 8, locations_buffer[i] +8):
					surrounding_hex.append(buffer[j])
			else:
				for j in range(locations_buffer[i],locations_buffer[i] + 16):
					surrounding_hex.append(buffer[j])
		else:
			for j in range(locations_buffer[i]-columns[i],len(buffer)):
				surrounding_hex.append(buffer[j])

	var num_results = len(results_buffer)
	results_buffer.resize(num_results*16)
	print("results found: ", num_results)
	
	
	# to match the loop in draw
	for i in range(num_results):
		results_buffer[i*16] = results_buffer[i] 
	results_recieved = true
	queue_redraw()
	
func update_scroll(buffer):
	_total_rows = len(buffer) - 2
	row_index = clamp(row_index,0, max(_total_rows - OFFSET,0))
	print("total rows: ", _total_rows)

func set_row_index(i):
	var visible_rows = int(size.y)
	var max_index = max(_total_rows - OFFSET ,0)
	i = clamp(i,0,max_index)
	
	if row_index != i:
		row_index = i
		queue_redraw()
		
func get_row_index():
	return row_index
	
func get_visible_row_count()-> int:
	var line_height = int(font.get_height(FONT_SIZE))
	return int(size.y)/ line_height

func set_wrapped_buffer(b):
	_wrapped_buffer = b
	queue_redraw()
	
func _draw() -> void:
	if _wrapped_buffer == null:
		return
		
	if results_recieved:
		var hex_to_string = get_parent().get_parent().get_parent().hex_text._hex_to_string

		var results = results_buffer
		var locations = locations_buffer
		
		var begin_offset:int = row_index * _row_width
		
		if begin_offset > len(surrounding_hex):
			return
		var line_height:= int(font.get_height(FONT_SIZE))
		var displayed_row_count:int = get_visible_row_count()
		
		var pos:= Vector2(0,0)
		
		for visual_row in displayed_row_count:
			#the offsets for the rest of the visible rows
			var row_begin_offset: int = begin_offset + visual_row * _row_width
			if row_begin_offset >= len(surrounding_hex):
				break
				
			# end of signatures row
			var row_end_offset = row_begin_offset + _row_width
			if row_end_offset > len(surrounding_hex):
				row_end_offset = len(surrounding_hex)
				
			pos += Vector2(3, font.get_ascent(FONT_SIZE))
			print("start ", row_begin_offset, " end ", row_end_offset)
			#offset location
			draw_string(font, pos, results_buffer[row_begin_offset],0,-1,FONT_SIZE,FONT_COLOUR)
			pos.x += 40 +  separation -1
			
			#the hex surrounding it
			var hex_string = ""
			for i in range(row_begin_offset,row_end_offset):
				hex_string += str(hex_to_string[surrounding_hex[i]], " ")
				
			draw_string(font, pos, hex_string,0,-1,FONT_SIZE, FONT_COLOUR)

			#reset for next
			pos.x = 0
			pos.y -= font.get_ascent(FONT_SIZE)
			pos.y += line_height
	else:
		results_buffer.clear()
		locations_buffer.clear()
		surrounding_hex.clear()
