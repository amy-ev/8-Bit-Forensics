extends TextureRect

var _file_name: String 
@onready var _file_icon:Texture2D
@onready var pc = get_parent().get_parent().get_parent().get_parent()

func _ready() -> void:
	if Global.first_image_carved:
		set_visible(true)
	
func _process(_delta: float) -> void:
	$file_name.text = _file_name
	texture = _file_icon

func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_double_click():
		print(_file_icon.get_meta("file_name"))
		print(get_meta("file_name"))
		
		var image_viewer = preload("res://pc/level2/viewer/image_viewer.tscn").instantiate()
		var image = Image.load_from_file("user://evidence_files/"+get_meta("file_name"))
		var img = ImageTexture.create_from_image(image)
		#var img:Texture2D = load("res://evidence_files/"+_file_icon.get_meta("file_name"))
		image_viewer.get_node("image").texture = img
		
		var screen = get_parent().get_parent().get_parent()
		screen.add_child(image_viewer)
		
		if _file_icon.get_meta("file_name") == "image1.jpg":
			if pc.has_node("dialogue_display"):
				pc.remove_child(pc.get_node("dialogue_display"))
			var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
			pc.add_child(dialogue)
			dialogue.load_dialogue("res://dialogue/json_files/dialogue.json", "h6.0")

		elif _file_icon.get_meta("file_name") == "image4.jpg":
			if pc.has_node("dialogue_display"):
				pc.remove_child(pc.get_node("dialogue_display"))
			var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
			pc.add_child(dialogue)
			dialogue.load_dialogue("res://dialogue/json_files/dialogue.json", "h7.0")
	
			await pc.get_node("dialogue_display").tree_exited
			Global.emit_signal("all_images_carved")
