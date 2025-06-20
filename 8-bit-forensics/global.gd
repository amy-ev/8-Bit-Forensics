extends Node

@export var magnification: int = 3
@export var days: Array = []

signal selected(selected_node:File, real_file:String)

signal note_selected(note_topic:String)

signal level_unlocked(day:String)
