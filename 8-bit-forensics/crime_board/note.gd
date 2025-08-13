extends TextureRect

@export var note_topic:String

func _ready() -> void:
	var content = open_json("res://crime_board/note_content.json")
	note_topic = content[name]["text"]


func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.is_double_click():
			Global.note_selected.emit(note_topic)

func open_json(file_path):
	if FileAccess.file_exists(file_path):

		var notes = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", notes.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(notes.get_as_text())
		if error == OK:
			var json_dict = json.data
			
			notes.close()
			return json_dict
		else:
			print("error code:" , error)
			notes.close()
