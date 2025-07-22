extends Control
class_name LoadFile

@onready var client_scene = preload("res://file_dialog/client.tscn")
@onready var files = preload("res://file_dialog/file.tscn")
#@onready var saved_dialog_scene = preload("res://file_dialog/save_file.tscn")
@onready var metadata_labels = preload("res://metadata/metadata_label.tscn")
@onready var hex_scene = preload("res://hex_viewer/hex_viewer.tscn")

@export var file_icon: ImageTexture
@export var selected_file: String
@export var file_idx:String

var client:Node
var current_rect: ColorRect

var file: File

func _ready() -> void:
	add_files(file_count("res://jpg_folder/"))

	if get_parent().name == "metadata_window":
		#start server python script
		#TODO: CHANGE TO FALSE
		OS.create_process("C:/Users/Amy/Desktop/8-Bit-Forensics/8-bit-forensics/python_files/start.bat",[],true) # true = terminal popup (for debugging)
	Global.connect("selected",_on_file_selected)
	
	# TODO: REMOVE FROM HERE AND ADD BOTH LOAD_FILE AND SAVE_FILE TO A DIALOG WINDOW SCENE
	#var saved_dialog = saved_dialog_scene.instantiate()
	#add_child(saved_dialog)
	#var dialog_node = saved_dialog.get_node(".")
	#dialog_node.position.x = get_node(".").position.x + (get_node(".").size.x * 2)
	# ---------------------------
	
func _on_load_button_pressed() -> void:
	print(get_parent().name)
	Global.selected_file = selected_file
	
	if get_parent().name == "metadata_window":
		var metadata_thumbnail = get_parent().get_node("thumbnail_column/thumbnail")
		var metadata_column = get_parent().get_node("scroll/data_container")
		
		#start client godot script
		var client = client_scene.instantiate()
		add_child(client)
		await client.tree_exited
		#kill server python script
		OS.create_process("C:/Users/Amy/Desktop/8-Bit-Forensics/8-bit-forensics/python_files/kill.bat",[],true)
		
		metadata_thumbnail.texture = load("res://jpg_folder/"+selected_file)
		metadata_thumbnail.size = Vector2(44,32)
		
		var json_dict = open_json("res://python_files/metadata.json")
		var file_idx = selected_file.replacen("photo", "")
		file_idx = file_idx.replacen(".jpg", "")

		if typeof(json_dict) == TYPE_DICTIONARY:
			if json_dict.has("file_%s" %file_idx):
				if metadata_column.get_child_count() > 0:
					for child in metadata_column.get_children():
						metadata_column.remove_child(child)
				for key in json_dict["file_%s" % file_idx]:
					
					var key_and_value = HBoxContainer.new()
					key_and_value.custom_minimum_size = Vector2(162.0,10.0)
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

	elif get_parent().name == "hex_viewer":
		get_parent().open_file("res://jpg_folder/"+selected_file)
		
	queue_free()
	
func add_files(file_no:int):

	for i in file_no:
		file = files.instantiate()
		$file_dialog/window/file_container.add_child(file)
		# named file to force automatic naming system = file1, file2 etc
		file.name = "file"
		file._file_name = file.name
		#file_icon = load("res://assets/file_dialog/icon-x3.png")
		file_icon = ImageTexture.create_from_image(Image.load_from_file("res://assets/file_dialog/icon.png"))
		#file_icon = ImageTexture.create_from_image(Image.load_from_file("res://jpg_folder/photo"+str(i)+".jpg"))
		file._file_icon = file_icon
		
		#TODO: change to match a variety of files
		file._file_icon.set_meta("file_name","photo"+str(i)+".jpg")
	
		# dynamically size the file_container grid seperations 
		$file_dialog/window/file_container.size.x = $file_dialog/window.size.x - 10
		$file_dialog/window/file_container.size.y = $file_dialog/window.size.y
		$file_dialog/window/file_container.position.x = 5
		$file_dialog/window/file_container.position.y = 4
		$file_dialog/window/file_container.add_theme_constant_override("h_separation", file.get_node("select/select_shape").shape.size.x + 8)
		$file_dialog/window/file_container.add_theme_constant_override("v_separation", (file.get_node("select/select_shape").shape.size.y)+(file.get_node("file_name").size.y))
	


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
		# if the file is not the godot import 
		if not f.contains(".import"):
			files_no += 1
	dir.list_dir_end()
	return files_no
	
func _on_exit_pressed() -> void:
	OS.create_process("C:/Users/Amy/Desktop/8-Bit-Forensics/8-bit-forensics/python_files/kill.bat",[],true)
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
	
	if get_parent().name == "metadata_window":
		file_idx = selected_file.replacen("photo", "")
		file_idx = file_idx.replacen(".jpg", "")
		get_parent().current_image = file_idx
	
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
