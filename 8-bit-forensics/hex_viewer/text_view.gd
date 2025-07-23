extends Control


@export var font: FontFile

var _wrapped_buffer = null

var row_index:= 0
var _row_width := 16
var char_width := 0
var _total_rows := 0

var offset_gap := 0
var hex_text_gap := 0
var converted_text_gap := 0
var separation := 0

var _hex_to_string := []

var OFFSET:int
var FONT_SIZE:= 8
var FONT_COLOUR:= Color(0.322, 0.282, 0.224)

func _ready() -> void:
	
	OFFSET = get_visible_row_count() - 1
	
	var hex = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"]
	
	for i in 256:
		# i>>4 shift right 4 bits
		# i & 0xf get last 4 bits
		_hex_to_string.append(str(hex[(i >> 4) & 0xf], hex[i & 0xf]))
		
	var char_size = font.get_string_size("A",0,-1,FONT_SIZE)
	char_width = int(char_size.x)
	
	offset_gap = char_width * 7
	hex_text_gap =  char_width * (3 * _row_width - 2)
	converted_text_gap = char_width * _row_width
	separation = char_width * 3
	
	
func set_wrapped_buffer(b):
	_wrapped_buffer = b
	queue_redraw()
	
func update_scroll(buffer):
	_total_rows = len(buffer) / _row_width
	row_index = clamp(row_index,0, max(_total_rows - OFFSET,0))
	
	
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
	
func _draw() -> void:
	if _wrapped_buffer == null:
		return
		#stop when len(buffer) is reached as it is the end of the file
	var buffer:PackedByteArray = _wrapped_buffer.buffer
	
	#each bytes_row starts on a multiple of 16 (and 0 for first bytes_row)
	var begin_offset:= row_index * _row_width
	if begin_offset > len(buffer):
		return
		
	var line_height:= int(font.get_height(FONT_SIZE))
	var displayed_row_count:= get_visible_row_count()
	
	var pos:= Vector2(0,0)
	
	for visual_row in displayed_row_count:
		#the offsets for the rest of the visible rows
		var row_begin_offset: int = begin_offset + visual_row * _row_width
		if row_begin_offset >= len(buffer):
			break
			
		# end of bytes_row
		var row_end_offset = row_begin_offset + _row_width
		if row_end_offset > len(buffer):
			row_end_offset = len(buffer)
			
		pos += Vector2(3, font.get_ascent(FONT_SIZE))
		
		#left side offset labels
		draw_string(font, pos, _offset_to_string(row_begin_offset), 0, -1,FONT_SIZE, FONT_COLOUR)
		pos.x += offset_gap + separation
		
		#hex text viewer
		var hex_string = ""
		for i in range(row_begin_offset, row_end_offset):
			hex_string += str(_hex_to_string[buffer[i]], " ")
		
		draw_string(font, pos, hex_string,0,-1,FONT_SIZE,FONT_COLOUR)
		pos.x += hex_text_gap + separation -1
		
		#converted text TODO: determine if should be kept
		var bytes_row = buffer.slice(row_begin_offset, row_end_offset - 1)
		for i in len(bytes_row):
			var x = bytes_row[i]
			# if byte would be a space or del then change to a '.' 
			if x < 32 or x >= 127:
				bytes_row[i] = 46
		var decoded_string = bytes_row.get_string_from_ascii()
		draw_string(font,pos,decoded_string,0,-1,FONT_SIZE,FONT_COLOUR)
		
		#reset for next
		pos.x = 0
		pos.y -= font.get_ascent(FONT_SIZE)
		pos.y += line_height
		

func _offset_to_string(offset):
	#shift by x bits, 
	#grab 1st, 2nd, 3rd byte and least significant respectively
	return str(
	_hex_to_string[(offset >> 24) & 0xff], 
	_hex_to_string[(offset >> 16) & 0xff], 
	_hex_to_string[(offset >> 8) & 0xff], 
	_hex_to_string[offset & 0xff])
