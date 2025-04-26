extends Control

@onready var client_scene = preload("res://file_dialog/client.tscn")
@onready var files = preload("res://file_dialog/file.tscn")

@export var file_icon: ImageTexture
@export var selected_file: String

var file: File

func _ready() -> void:
	add_files(file_count("res://jpg_folder/"))
	OS.create_process("C:/Users/Amy/Desktop/8-Bit-Forensics/8-bit-forensics/python_files/start.bat",[],true) 
	# true for debugging 
	
func _on_load_button_pressed() -> void:
	selected_file = $button_border/load_button.text
	var client = client_scene.instantiate()
	add_child(client)
	
func add_files(file_no:int):

	for i in file_no:
		file = files.instantiate()
		$file_dialog/window/file_container.add_child(file)
		# named file to force automatic naming system = file1, file2 etc
		file.name = "file"
		file._file_name = file.name
		file_icon = ImageTexture.create_from_image(Image.load_from_file("res://assets/file_dialog/icon-x3.png"))
		#file_icon = ImageTexture.create_from_image(Image.load_from_file("res://jpg_folder/photo"+str(i)+".jpg"))
		file._file_icon = file_icon
		file_icon.set_meta("file_name","photo"+str(i)+".jpg")
		print(file_icon.get_meta("file_name"))
		
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
