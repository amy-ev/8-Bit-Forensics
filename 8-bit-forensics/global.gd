extends Node

var selected_file:String

var magnification: int = 2
var user_path = ProjectSettings.globalize_path("user://")

var levels: Dictionary = {0:"note1",1:"note2",2:"note3",3:"note4",4:"note5",5:"note6",6:"note7",7:"note8"}
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

#day 2
var first_file_opened:bool
var first_image_carved:bool
var found_first_signature:bool
var found_signature_sandwich:bool
var hex_finished:bool

#day 3
var first_image_opened:bool
var metadata_finished:bool

#general
var debrief_given:bool
var pc_debrief_given:bool

#to be used when the level is selected via level select
#use to determine the folder contents.
var level_selected:bool

@export_category("Quiz Properties")
@export var answers = ["a","b","a","c"]
@export var quiz_dict = {"Day_1":["a","b","c"], "Day_2":["a","b","c"], "Day_3":["a","b","c"]}

#dialogue based
signal text_finished()
signal dialogue_triggered(topic:String)
signal next_step(stage:Node)
signal answer_response(is_correct:bool)

#day 1
signal create_image_file()
signal evidence_finished()

#day 2
signal signature_found(locations:Array)
signal all_images_carved()

#day 3
signal metadata_selected(selected:Node)
signal metadata_help(key:Node)
signal all_metadata_found()

#general
signal level_unlocked(day:String)
signal selected(selected_node:File, real_file:String)
signal option_selected(option:String)
signal item_pressed(selected:Node)
signal note_selected(note_topic:String)

#quiz 
signal answer(day:String, answer:int)
signal quiz_response()

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

func set_save(file_path):
	print(unlocked)
	var save_dict = {"days":{"unlocked": unlocked}}
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.WRITE)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", file.get_open_error())
		var json_string = JSON.stringify(save_dict)
		file.store_line(json_string)
		
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
