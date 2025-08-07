extends NinePatchRect

var load_file_open:bool = false
var search_open:bool = false
var select_open:bool = false
var already_carved:bool

var file_no:int
var file_icon: Texture2D

var first_search:String

@onready var hex_text = $v_sort/scroll_manager/sort/window/original_file/hex_text
@onready var scroll_bar = $v_sort/scroll_manager/scroll_bar
@onready var tabs = $v_sort/scroll_manager/sort/window
@onready var results_text = $v_sort/results_scroll_manager/results

@onready var search_window = preload("res://hex_viewer/search.tscn")
@onready var select_window = preload("res://hex_viewer/select.tscn")

var buffer_len:int

class BufferWrapper:
	var buffer = PackedByteArray()

var _wrapped_buffer:= BufferWrapper.new()
var _open_dialogue = null
var _file_path:= ""
var start_end:= []


func _ready() -> void:
	hex_text.set_wrapped_buffer(_wrapped_buffer)
	results_text.set_wrapped_buffer(_wrapped_buffer)

func open_file(file_path:String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)

		var buffer = file.get_buffer(file.get_length())
		buffer_len = file.get_length()
		file.close()
		
		_wrapped_buffer.buffer = buffer
		_file_path = file_path
		
		scroll_bar.update_scroll(buffer)
		hex_text.update_scroll(buffer)
		
		hex_text.queue_redraw()
		if Global.first_file_opened:
			pass
	else:
		print("failed to open file")
		return
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("find"):
		if !search_open && !select_open && !load_file_open:
			search_open = true
			add_child(search_window.instantiate())
			
	if event.is_action_pressed("select_block"):
		if !select_open && !search_open && !load_file_open:
			select_open = true
			add_child(select_window.instantiate())

func _on_load_pressed() -> void:
	if !search_open && !select_open:
		add_child(load("res://file_dialog/load_file.tscn").instantiate())
		load_file_open = true


func _on_window_tab_changed(tab: int) -> void:
	var buffer
	if tab != 0:
		hex_text = get_node("v_sort/scroll_manager/sort/window/new_file"+str(tab)+"/hex_text")
		buffer = hex_text._wrapped_buffer
	else:
		hex_text = $v_sort/scroll_manager/sort/window/original_file/hex_text
		buffer = _wrapped_buffer.buffer
	results_text.results_recieved = false
	results_text.queue_redraw()
	
	hex_text.update_scroll(buffer)
	scroll_bar.update_scroll(buffer)


func _on_save_pressed() -> void:
	if tabs.current_tab != 0:
		var buffer = tabs.get_child(tabs.current_tab).get_node("hex_text")._wrapped_buffer
		
		var start_str = ""
		var end_str = ""
		
		for i in range(4):
			start_str += str(hex_text._hex_to_string[buffer[i]]+ "") 

		for i in range(len(buffer)-2, len(buffer)):
			end_str += str(hex_text._hex_to_string[buffer[i]]+ "")

		if (start_str == "ffd8ffe1" || start_str == "ffd8ffe0") && end_str == "ffd9":
			if !already_carved:
				file_no +=1
				var file = FileAccess.open("res://evidence_files/image"+ str(file_no)+ ".jpg", FileAccess.WRITE)

				file.store_buffer(tabs.get_child(tabs.current_tab).get_node("hex_text")._wrapped_buffer)
				file.close()
				
				var icon = load("res://viewer/icon.tscn").instantiate()
				get_parent().add_child(icon)

				icon._file_icon.set_meta("file_name","image"+str(file_no)+".jpg")
				icon._file_name = "file "+ str(file_no)
				
				if !Global.first_image_carved:
					icon.set_visible(true)
					
					Global.first_image_carved = true
				$save.disabled = true
				$save.release_focus()
			else:
				file_no = file_no
				
				#prevent enter button used to skip dialogue from forcing repeated saves
				$save.disabled = true
				$save.release_focus()
		else:
			$save.disabled = true
			$save.release_focus()

func _on_find_pressed() -> void:
	if results_text.results_recieved:
		var row = results_text.get_row_index()
		var location = results_text.locations_buffer[results_text.get_row_index()]
		$v_sort/scroll_manager._scroll_to(location/16)
