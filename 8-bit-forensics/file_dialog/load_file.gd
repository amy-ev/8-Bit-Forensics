extends Control
class_name LoadFile

@onready var client_scene = preload("res://file_dialog/client.tscn")
@onready var files = preload("res://file_dialog/file.tscn")
@onready var metadata_labels = preload("res://metadata/metadata_label.tscn")

@export var file_icon: Texture2D
@export var selected_file: String
@export var file_idx:String

var client:Node
var current_rect: ColorRect

var file: File
var user_path = ProjectSettings.globalize_path("user://")

@onready var parent = get_parent()
var evidence_folder:String

var metadata_count:int

func _ready() -> void:
	# for level select 
	if !Global.level_selected:
		evidence_folder = "user://evidence_files/"
	else:
		if Global.unlocked == 1:
			evidence_folder = "user://evidence_files/"
			
		elif Global.unlocked == 2:
			evidence_folder = "user://metadata_images/"
			
		
	Global.connect("selected",_on_file_selected)
	
	add_files(file_count(evidence_folder))

	if parent.name == "metadata_window":
		#start server python script
		OS.create_process("cmd.exe", ["/C", "cd " + user_path+"/python_files && start.bat"])

func _on_load_button_pressed() -> void:
	Global.selected_file = selected_file
	
	if parent.name == "metadata_window":
		var metadata_thumbnail = parent.get_node("thumbnail_column/thumbnail")
		var metadata_column = parent.get_node("scroll/data_container")
		
		#start client godot script
		var client = client_scene.instantiate()
		add_child(client)
		await client.tree_exited
		#kill server python script
		OS.create_process("cmd.exe", ["/C", "cd " + user_path+"/python_files && kill.bat"])
		var image = Image.load_from_file(evidence_folder + selected_file)
		var img = ImageTexture.create_from_image(image)
		metadata_thumbnail.texture = img
		metadata_thumbnail.size = Vector2(44,32)
		
		var json_dict = open_json("user://python_files/metadata.json")
		var file_idx = selected_file.replacen("image", "")
		file_idx = file_idx.replacen(".jpg", "")

		if typeof(json_dict) == TYPE_DICTIONARY:
			print(file_idx)
			if json_dict.has("file_%s" %file_idx):
				if metadata_column.get_child_count() > 0:
					for child in metadata_column.get_children():
						metadata_column.remove_child(child)
				for key in json_dict["file_%s" % file_idx]:
					
					var key_and_value = HBoxContainer.new()
					key_and_value.custom_minimum_size = Vector2(165.0,10.0)
					key_and_value.add_theme_constant_override("separation", 0)
					key_and_value.clip_contents = true
					metadata_column.add_child(key_and_value)
					
					var key_label = metadata_labels.instantiate()
					key_label.text = key
					#key_label.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
					key_label.custom_minimum_size = Vector2(70.0, 10.0)
					key_label.get_node("select/select_shape").shape.size.x = 165.0
					key_and_value.add_child(key_label)

					var value_label = metadata_labels.instantiate()
					value_label.text = json_dict["file_%s" % file_idx][key]
					value_label.set_autowrap_mode(TextServer.AUTOWRAP_WORD_SMART)
					value_label.custom_minimum_size = Vector2(100.0, 10.0)
					value_label.get_node("selected").queue_free()
					value_label.get_node("select").queue_free()
					key_and_value.add_child(value_label)
		else:
			print("Type: ", type_string(typeof(json_dict)))
		if !Global.first_image_opened:
			Global.first_image_opened = true
			if parent.get_parent().get_parent().has_node("dialogue_display"):
				parent.get_parent().get_parent().remove_child(parent.get_parent().get_parent().get_node("dialogue_display"))
			var dialogue = load("res://dialogue/dialogue_display.tscn").instantiate()
			parent.get_parent().get_parent().add_child(dialogue)
			dialogue.load_dialogue("res://dialogue/dialogue.json", "m2.0")
		var label = Label.new()
		if parent.get_parent().has_node("Label"):
			parent.get_parent().remove_child(parent.get_parent().get_node("Label"))
			
		parent.get_parent().add_child(label,true)
		
		var current_image = Global.get_image(evidence_folder + selected_file)
		
		if current_image == Global.img1:
			metadata_count = Global.img1_count
			label.text = str(metadata_count)
		elif current_image == Global.img2:
			metadata_count = Global.img2_count
			label.text = str(metadata_count)
		elif current_image == Global.img3:
			metadata_count = Global.img3_count
			label.text = str(metadata_count)
		elif current_image == Global.img4:
			metadata_count = Global.img4_count
			label.text = str(metadata_count)

			
	elif parent.name == "hex_viewer":
		parent.open_file(evidence_folder + selected_file)
		if !Global.first_file_opened && selected_file == "SD-image-file.001":
			
			Global.first_file_opened = true
			
			if parent.get_parent().get_parent().has_node("dialogue_display"):
				parent.get_parent().get_parent().remove_child(parent.get_parent().get_parent().get_node("dialogue_display"))
			var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
			parent.get_parent().get_parent().add_child(dialogue)
			dialogue.load_dialogue("res://dialogue/dialogue.json", "h2.0")


		parent.load_file_open = false
		
		var tabs = parent.get_node("v_sort/scroll_manager/sort/window")
		
		if tabs.get_child_count() > 1:
			var children = []
			for i in tabs.get_children():
				if i.name != "original_file":
					children.append(i)
			for child in children:
				tabs.remove_child(child)
				
		var search_results = parent.get_node("v_sort/results_scroll_manager/results")
		search_results.results_recieved = false
		search_results.queue_redraw()
		
		
	queue_free()
	
func add_files(file_no:int):

	for i in file_no:
		
		file = files.instantiate()
		$file_container.add_child(file)
		# named file to force automatic naming system = file1, file2 etc
		file.name = "file"
		file._file_name = file.name
		print("file: ",i)
		var img:Texture2D = load("res://assets/UI/file-icon.png")
		file_icon = img

		file._file_icon = file_icon
		
		if parent.name == "metadata_window":
			file._file_icon.set_meta("file_name","image"+str(i+1)+".jpg")
			file.set_meta("file_name","image"+str(i+1)+".jpg")
			
		elif parent.name == "hex_viewer":
			if i == 0:
				file.set_meta("file_name","SD-image-file.001")
			else:
				file.set_meta("file_name","image"+str(i)+".jpg")
				
		# dynamically size the file_container grid seperations 
		$file_container.add_theme_constant_override("h_separation", file.get_node("select/select_shape").shape.size.x + 2)
		$file_container.add_theme_constant_override("v_separation", (file.get_node("select/select_shape").shape.size.y)+(file.get_node("file_name").size.y))
	


func file_count(file_path:String) -> int:
	#var dir = DirAccess.open("res://jpg_folder/").get_files()
	# print(len(dir)
	var dir = DirAccess.open(file_path)
	dir.list_dir_begin()
	var files_no:int = 0
	while true:
		var f = dir.get_next()
		# if there is no more files found
		if f == "":
			break
		if not f.contains(".import"):
			if parent.name == "metadata_window":
				if f.contains(".jpg"):
					files_no += 1
			elif parent.name == "hex_viewer":
				if !f.contains(".jpg"):
					files_no += 1
					
	dir.list_dir_end()
	return files_no
	
func _on_exit_pressed() -> void:
	if parent.name == "metadata_window":
		OS.create_process("cmd.exe", ["/C", "cd " + user_path+"/python_files && kill.bat"])
		
	elif parent.name == "hex_viewer":
		parent.load_file_open = false
		
	queue_free()

func _on_file_selected(selected_node:File, real_file:String):
	# obtain the colour rect node of the selected file emitted
	var selected_rect = selected_node.get_node("selected")
	# if current_rect is not null and current_rect is not from the file just emitted
	if current_rect and current_rect != selected_rect:
		current_rect.visible = false
	
	selected_rect.visible = true
	current_rect = selected_rect
	
	selected_file = real_file
	
	print("selected_node: %s, real_file: %s, selected_file: %s "%[selected_node, real_file, selected_file])
	
	if parent.name == "metadata_window":
		file_idx = selected_file.replacen("image", "")
		file_idx = file_idx.replacen(".jpg", "")
		parent.current_image = file_idx
	
func open_json(file_path):
	if FileAccess.file_exists(file_path):

		var metadata = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", metadata.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(metadata.get_as_text())
		if error == OK:
			var json_dict = json.data
			
			metadata.close()
			return json_dict
		else:
			print("error code:" , error)
			metadata.close()
