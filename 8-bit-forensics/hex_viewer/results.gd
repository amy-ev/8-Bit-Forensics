extends Control


var font: FontFile

var _wrapped_buffer = null

var results_buffer = []

var row_index:= 0
var _row_width := 16
var char_width := 0
var _total_rows := 0

var offset_gap := 0
var hex_text_gap := 0
var separation := 0


@onready var carved_block:=PackedByteArray()

var OFFSET:int
var FONT_SIZE:= 8
var FONT_COLOUR:= Color(0.322, 0.282, 0.224)

func _ready() -> void:
	font = preload("res://Vaticanus-G3yVG.ttf")
	Global.connect("signature_found", _on_results_found)

func _on_results_found(results:Array):
	results_buffer = results
	set_visible(true)
	queue_redraw()
	
func get_visible_row_count()-> int:
	var line_height = int(font.get_height(FONT_SIZE))
	return int(size.y)/ line_height
	
func _draw() -> void:
	var results = results_buffer
	var begin_offset:int = row_index * _row_width
	if begin_offset > len(results):
		return
	
	
	var line_height:= int(font.get_height(FONT_SIZE))
	var displayed_row_count:int = get_visible_row_count()
	
	var pos:= Vector2(0,0)
	
	for visual_row in displayed_row_count:
		#the offsets for the rest of the visible rows
		var row_begin_offset: int = begin_offset + visual_row * _row_width
		if row_begin_offset >= len(results):
			break
			
		# end of bytes_row
		var row_end_offset = row_begin_offset + _row_width
		if row_end_offset > len(results):
			row_end_offset = len(results)
			
		pos += Vector2(3, font.get_ascent(FONT_SIZE))
		
		#hex text viewer
		var hex_string = ""
		for i in range(row_begin_offset, row_end_offset):
			hex_string += str(results[i], " ")
		
		draw_string(font, pos, hex_string,0,-1,FONT_SIZE,FONT_COLOUR)
		pos.x += hex_text_gap +  separation -1


		#reset for next
		pos.x = 0
		pos.y -= font.get_ascent(FONT_SIZE)
		pos.y += line_height
	
