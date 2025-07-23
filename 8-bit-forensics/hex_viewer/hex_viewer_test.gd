extends NinePatchRect


@onready var hex_text = $scroll_manager/window/new_file/hex_text
@onready var scroll_bar = $scroll_manager/scroll_bar

class BufferWrapper:
	var buffer = PackedByteArray()

var _wrapped_buffer:= BufferWrapper.new()
var _open_dialogue = null
var _file_path:= ""


func _ready() -> void:
	hex_text.set_wrapped_buffer(_wrapped_buffer)

func open_file(file_path:String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	var file_length = file.get_length()
	var buffer = file.get_buffer(file_length)
	file.close()
	
	_wrapped_buffer.buffer = buffer
	
	scroll_bar.update_scroll(buffer)
	hex_text.update_scroll(buffer)
	
	hex_text.queue_redraw()
	
	_file_path = file_path

func _on_load_pressed() -> void:
	add_child(load("res://file_dialog/load_file.tscn").instantiate())
