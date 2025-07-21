extends Node2D

@onready var note = preload("res://crime_board/note_content.tscn")

@onready var note_rects = []
@export var scaled_by: Vector2
var days_unlocked = 0
var note_open:bool

func _ready() -> void:
	scale = scale * Utility.window_mode()
	Global.connect("note_selected", _open_note)
	Global.connect("level_unlocked", _show_note)
	
	_check_unlocked()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _open_note(note_topic:String):
	var note_content = note.instantiate()
	if !note_open:
		note_content.get_child(0).get_child(0).text = note_topic
	#TODO: connect a json file with the corresponding educational notes
		$bottom_screen.add_child(note_content)
		note_open = true
	else:
		$bottom_screen/note.queue_free()
		await get_tree().process_frame
		note_open = false
		note_content.get_child(0).get_child(0).text = note_topic
		$bottom_screen.add_child(note_content)
		note_open = true
		
func _show_note(day:String):
	Global.days.append(day)
	# change to loop through array of days and show all unlocked 
	#print(day)
	get_node("bottom_screen/"+day).visible = true
	#print(Global.days)
	
func _on_unlock_debug_pressed() -> void:
	#move to the end of the day button + appending day to Global array
	Global.unlocked += 1
	_check_unlocked()

func _check_unlocked():
	for i in Global.unlocked:
		for key in Global.levels:
			var value = Global.levels[i]
			Global.level_unlocked.emit(value)
			
func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if note_open:
			$bottom_screen/note.queue_free()
			note_open = false
