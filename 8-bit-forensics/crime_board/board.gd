extends TextureRect

@onready var note = preload("res://crime_board/note_content.tscn")

@onready var note_rects = []
@export var scaled_by: Vector2
var days_unlocked = 0

func _ready() -> void:
	update_size()
	Global.connect("note_selected", _open_note)
	Global.connect("level_unlocked", _show_note)

func _open_note(note_topic:String):
	var note_content = note.instantiate()
	note_content.get_child(0).text = note_topic
	#TODO: connect a json file with the corresponding educational notes
	add_child(note_content)

func _show_note(day:String):
	Global.days.append(day)
	# change to loop through array of days and show all unlocked 
	#print(day)
	get_node(day).visible = true
	#print(Global.days)
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()

func update_size():
	var original_size = size

	size = DisplayServer.window_get_size()
	
	# keeping it scaled to the x axis - prevents distortion of the images
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	
	for note_rect in range(get_children().size()-1):
		if get_child(note_rect).name.contains("note"):
			get_child(note_rect).get_node("area/area_shape").shape.size = get_child(note_rect).get_node("area/area_shape").shape.size / scaled_by
			get_child(note_rect).get_node("area/area_shape").position = get_child(note_rect).get_node("area/area_shape").position / scaled_by

func _on_unlock_debug_pressed() -> void:
	#move to the end of the day button + appending day to Global array
	days_unlocked += 1
	
	for i in days_unlocked:
		for key in Global.levels:
			var value = Global.levels[i]
			Global.level_unlocked.emit(value)
