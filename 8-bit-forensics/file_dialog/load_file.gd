extends Control
class_name LoadFile

@onready var client_scene = preload("res://file_dialog/client.tscn")
@onready var files = preload("res://file_dialog/file.tscn")
#@onready var saved_dialog_scene = preload("res://file_dialog/save_file.tscn")

@export var file_icon: ImageTexture
@export var selected_file: String

var client:Node
var current_rect: ColorRect

var file: File

func _ready() -> void:
	add_files(file_count("res://jpg_folder/"))
	# true = terminal popup (for debugging)
	OS.create_process("C:/Users/Amy/Desktop/8-Bit-Forensics/8-bit-forensics/python_files/start.bat",[],true) 
	Global.connect("selected",_on_file_selected)
	
	# TODO: REMOVE FROM HERE AND ADD BOTH LOAD_FILE AND SAVE_FILE TO A DIALOG WINDOW SCENE
	#var saved_dialog = saved_dialog_scene.instantiate()
	#add_child(saved_dialog)
	#var dialog_node = saved_dialog.get_node(".")
	#dialog_node.position.x = get_node(".").position.x + (get_node(".").size.x * 2)
	# ---------------------------
	
func _on_load_button_pressed() -> void:

	var client = client_scene.instantiate()
	add_child(client)
	await client.tree_exited

	
	var metadata_text = get_parent().get_node("window/metadata")
	#metadata_text.clear()
	
	var json_dict = open_json("res://python_files/metadata.json")
	
	var file_idx = selected_file.replacen("photo", "")
	file_idx = file_idx.replacen(".jpg", "")
	print("selected file: %s" %selected_file)
	#print("file idx: %s" %file_idx)
	if typeof(json_dict) == TYPE_DICTIONARY:
		if json_dict.has("file_%s" %file_idx):

			for key in json_dict["file_%s" % file_idx]:
				
				#key
				#print(key)
				#value
				#print(json_dict["file_%s" % file_idx][key])
				metadata_text.add_text(key)
				metadata_text.add_text(" : ")
				metadata_text.add_text(json_dict["file_%s" % file_idx][key])
				metadata_text.newline()
		else:
			pass
	else:
		print("Type: ", type_string(typeof(json_dict)))
	queue_free()
	
	
func add_files(file_no:int):

	for i in file_no:
		file = files.instantiate()
		$file_dialog/window/file_container.add_child(file)
		# named file to force automatic naming system = file1, file2 etc
		file.name = "file"
		file._file_name = file.name
		#file_icon = load("res://assets/file_dialog/icon-x3.png")
		file_icon = ImageTexture.create_from_image(Image.load_from_file("res://assets/file_dialog/icon-x3.png"))
		#file_icon = ImageTexture.create_from_image(Image.load_from_file("res://jpg_folder/photo"+str(i)+".jpg"))
		file._file_icon = file_icon
		
		#TODO: change to match a variety of files
		file._file_icon.set_meta("file_name","photo"+str(i)+".jpg")
	
		# dynamically size the file_container grid seperations 
		$file_dialog/window/file_container.size.x = $file_dialog/window.size.x - (6 * Global.magnification) - 1
		$file_dialog/window/file_container.size.y = $file_dialog/window.size.y - (5 * Global.magnification)
		$file_dialog/window/file_container.position.x = (3 * Global.magnification)
		$file_dialog/window/file_container.position.y = (2 * Global.magnification)
		$file_dialog/window/file_container.add_theme_constant_override("h_separation", file.get_node("select/select_shape").shape.size.x)
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
	
func open_json(file_path):
	if FileAccess.file_exists(file_path):

		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", dialogue.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(dialogue.get_as_text())
		if error == OK:
			var json_dict = json.data
			
			dialogue.close()
			return json_dict
		else:
			print("error code:" , error)
			dialogue.close()
		#var json = json.parse(dialogue.get_as_text(), true)
		#var json_dict = json.get_parsed_text()

		#print(json_dict)
		#return json_dict
