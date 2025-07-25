extends Node


@export var magnification: int = 2
@export var levels: Dictionary = {0:"note1",1:"note2",2:"note3",3:"note4",4:"note5",5:"note6",6:"note7",7:"note8"}
@export var days: Array = []
@export var unlocked: int

@export var is_collected:bool

var form_name:String
var form_signed:String
var form_date:String

var is_first_bag:bool = true
var file_created:bool = false
var debrief_given:bool

var selected_file:String

@export var answers = ["a","b","a","c"]
@export var quiz_dict = {"Day_1":["a","b","c"], "Day_2":["a","b","c"], "Day_3":["a","b","c"]}

signal selected(selected_node:File, real_file:String)

signal note_selected(note_topic:String)

signal level_unlocked(day:String)

signal evidence_collected()
signal create_image_file()

signal answer(day:String, answer:int)

signal child_joined()

signal metadata_selected(selected:Node)

signal next_step(stage:Node)

signal answer_response(is_correct:bool)

signal item_pressed(selected:Node)
