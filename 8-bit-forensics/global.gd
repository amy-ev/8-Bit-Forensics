extends Node

@export var magnification: int = 3
@export var levels: Dictionary = {0:"note1",1:"note2",2:"note3",3:"note4",4:"note5",5:"note6",6:"note7",7:"note8"}
@export var days: Array = []
@export var unlocked: int

signal selected(selected_node:MyFile, real_file:String)

signal note_selected(note_topic:String)

signal level_unlocked(day:String)

signal evidence_collected()
