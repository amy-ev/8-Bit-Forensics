extends Node


var magnification: int = 2
var levels: Dictionary = {0:"note1",1:"note2",2:"note3",3:"note4",4:"note5",5:"note6",6:"note7",7:"note8"}
var days: Array = []

@export var unlocked: int

@export_category("Form Properties")
@export var form_name:String
@export var form_signed:String
@export var form_date:String

var is_first_bag:bool
var file_created:bool
var is_collected:bool

var debrief_given:bool
var pc_debrief_given:bool

var selected_file:String

@export_category("Quiz Properties")
@export var answers = ["a","b","a","c"]
@export var quiz_dict = {"Day_1":["a","b","c"], "Day_2":["a","b","c"], "Day_3":["a","b","c"]}

signal selected(selected_node:File, real_file:String)

signal note_selected(note_topic:String)

signal level_unlocked(day:String)

signal signature_found(locations:Array)
signal evidence_collected()
signal create_image_file()

signal answer(day:String, answer:int)

signal metadata_selected(selected:Node)

#old hex viewer 
signal hex_selected(row:int)

signal next_step(stage:Node)

signal answer_response(is_correct:bool)

signal item_pressed(selected:Node)

func day_start():
	match unlocked:
		0:
			is_first_bag = true
			file_created = false
			is_collected = false
			debrief_given = false
			pc_debrief_given = false
		_:
			is_first_bag = false
			file_created = true
			is_collected = true
			debrief_given = false
			pc_debrief_given = false
