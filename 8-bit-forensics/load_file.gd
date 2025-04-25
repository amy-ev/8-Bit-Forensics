extends Control

@onready var files = preload("res://file.tscn")
@export var _file_name: String
@export var _file_icon: ImageTexture

@export var selected_file: String
var _file: File


func _ready() -> void:
	add_files(file_count("res://jpg_folder/"))
	
	
func _on_load_button_pressed() -> void:
	print($load_button.text)
	selected_file = $load_button.text
	
func add_files(file_no:int):
	for i in file_no:
		_file = files.instantiate()
		$GridContainer.add_child(_file)
		_file.name = "file"
		_file.file_name = _file.name
		_file_icon = ImageTexture.create_from_image(Image.load_from_file("res://jpg_folder/photo"+str(i)+".jpg"))
		_file.file_icon = _file_icon


func file_count(file_path:String) -> int:
	#var dir = DirAccess.open("res://jpg_folder/").get_files()
	# print(len(dir)
	var dir = DirAccess.open(file_path)
	dir.list_dir_begin()
	var files_no:int 
	
	while true:
		var f = dir.get_next()
		if f == "":
			break
		if not f.contains(".import"):
			files_no += 1
	dir.list_dir_end()
	return files_no
	
