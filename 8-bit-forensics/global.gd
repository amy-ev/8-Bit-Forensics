extends Node

var selected_file:String

var magnification: int = 2
var user_path = ProjectSettings.globalize_path("user://")

var levels: Dictionary = {0:"note1",1:"note2",2:"note3",3:"note4",4:"note5",5:"note6",6:"note7"}
var days: Array = []

@export var unlocked:int = int(get_save(user_path +"savefile.json"))

@export_category("Form Properties")
@export var form_name:String
@export var form_signed:String
@export var form_date:String

#day 1
var is_first_bag:bool
var file_created:bool
var hash_verified:bool
var evidence_collected:bool
var hash_array:Array

#day 2
var first_file_opened:bool
var first_image_carved:bool
var found_first_signature:bool
var found_signature_sandwich:bool
var hex_finished:bool

#day 3
var first_image_opened:bool
var metadata_finished:bool
var img1:PackedByteArray 
var img2:PackedByteArray 
var img3:PackedByteArray 
var img4:PackedByteArray
var img1_count:int
var img2_count:int
var img3_count:int
var img4_count:int
#general
var debrief_given:bool
var pc_debrief_given:bool

#to be used when the level is selected via level select
#use to determine the folder contents.
var level_selected:bool

var correct_answers = [["b","a","a"],["a","b","c","b"],["c","d","c"]]

var question_count = [3,3,3]

var answer_options = {"0":[["a","b","c","d"],["a","b","c"],["a","b","c"]],\
					"1":[["a","b","c"],["a","b","c"],["a","b","c"]],\
					"2":[["a","b","c"],["a","b","c","d"],["a","b","c"]]}

#dialogue based
signal text_finished
signal dialogue_triggered(topic:String)
signal next_step(stage:Node)
signal answer_response(is_correct:bool)

#day 1
signal create_image_file
signal evidence_finished
signal inc_progressbar

#day 2
signal signature_found(locations:Array)
signal all_images_carved
signal hex_search_help
signal hex_select_help

#day 3
signal metadata_selected(selected:Node)
signal metadata_help(key:Node)
signal all_metadata_found

#general
signal level_unlocked(day:String)
signal selected(selected_node:File, real_file:String)
signal option_selected(option:String)
signal item_pressed(selected:Node)
signal note_selected(note_topic:String)

#quiz 
signal answer(answer:int)
signal quiz_response
signal exit_pressed

func get_save(file_path):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", file.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var dict = json.data
			var days = dict["days"]
			file.close()
			return days["unlocked"]
		else:
			print("error code:" , error)
			file.close()
	else:
		return "0"

func set_save(file_path):
	var save_dict = {"days":{"unlocked": unlocked}}
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", file.get_open_error())
		var json_string = JSON.stringify(save_dict)
		file.store_line(json_string)

func get_image(file_path):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var content = file.get_buffer(file.get_length())
		file.close()

		return content
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.cursor_set_custom_image(load("res://assets/UI/pressed_cursor_fullscreen.png"),0)
			else:
				DisplayServer.cursor_set_custom_image(load("res://assets/UI/pressed_cursor_window.png"),0)
		if event.is_released():
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.cursor_set_custom_image(load("res://assets/UI/cursor_fullscreen.png"),0)
			else:
				DisplayServer.cursor_set_custom_image(load("res://assets/UI/cursor_window.png"),0)
			
func day_start():

	debrief_given = false
	pc_debrief_given = false
	
	match unlocked:
		0:
			is_first_bag = true
			file_created = false
			hash_verified = false
			evidence_collected = false

			first_file_opened = false
			first_image_carved = false
			found_first_signature = false
			found_signature_sandwich = false
			hex_finished = false
			
			first_image_opened = false
			metadata_finished = false
		1:
			is_first_bag = false
			file_created = true
			hash_verified = true
			evidence_collected = true
			
			first_file_opened = false
			first_image_carved = false
			found_first_signature = false
			found_signature_sandwich = false
			hex_finished = false
			
			first_image_opened = false
			metadata_finished = false
		2:
			is_first_bag = false
			file_created = true
			hash_verified = true
			evidence_collected = true
			
			first_file_opened = true
			first_image_carved = true
			found_first_signature = true
			found_signature_sandwich = true
			hex_finished = true
			
			first_image_opened = false
			metadata_finished = false


#JPG FILES ARE NOT PRESENT ON EXPORT (even with it specifically set to export *.jpg)
# recreating the manual carving of the images from the evidence files allows for the jpgs to be created on run time
func create_images():
	var content1:PackedByteArray = _select("149000","14ed6d")
	img1 = content1 
	var file1 = FileAccess.open(user_path + "metadata_images/image1.jpg", FileAccess.WRITE)
	file1.store_buffer(content1)
	file1.close()
	
	var content2:PackedByteArray = _select("151000","1579ac")
	img2 = content2
	var file2 = FileAccess.open(user_path + "metadata_images/image2.jpg", FileAccess.WRITE)
	file2.store_buffer(content2)
	file2.close()
	
	var content3:PackedByteArray = _select("159000","15e958")
	img3 = content3
	var file3 = FileAccess.open(user_path + "metadata_images/image3.jpg", FileAccess.WRITE)
	file3.store_buffer(content3)
	file3.close()
	
	var content4:PackedByteArray = _select("161000","1664ce")
	img4 = content4
	var file4 = FileAccess.open(user_path + "metadata_images/image4.jpg", FileAccess.WRITE)
	file4.store_buffer(content4)
	file4.close()
	

func _select(start,end):
	var buffer = open_file(user_path+"evidence_files/SD-image-file.001")
	
	start = _hex_to_dec(start)
	end = _hex_to_dec(end)
	
	var carved_block:=PackedByteArray()
	for i in range(start,end+1):
		carved_block.append(buffer[i])
	return carved_block

func _hex_to_dec(input:String):
	var x = []
	var y = []
	
	var x_result:int
	var y_result:int
	
	#row
	var row = input.substr(0,input.length()-1)
	row = row.lstrip('0')
	for char in row:
		x.insert(0,char)
	
	for i in range(x.size()):
		x[i] = convert_hex(x[i])
		x_result += int(x[i]) * (16 ** i)

	#column
	var column = input.substr(input.length()-1)
	y.append(column)
	
	for i in range(y.size()):
		y[i] = convert_hex(y[i])
		y_result += int(y[i]) * (16 ** i)
	
	var hex_index:int
	
	if x_result == 0:
		hex_index = x_result + y_result
	else:
		hex_index = (x_result) * 16
		hex_index += y_result
	return hex_index
	
func convert_hex(i:String):
	i = i.to_upper()
	match i:
		"A":
			return "10"
		"B":
			return "11"	
		"C":
			return "12"
		"D":
			return "13"
		"E":
			return "14"
		"F":
			return "15"
		_:
			return i

func open_file(file_path:String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		file.close()
		return buffer
	else:
		print("failed to open file")
		return
	
