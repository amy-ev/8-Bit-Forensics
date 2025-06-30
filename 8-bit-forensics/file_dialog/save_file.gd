extends Control

@onready var files = preload("res://file_dialog/file.tscn")

@export var file_icon: CompressedTexture2D

var file: MyFile
var files_no:int = 0
var dir_path:String = "res://python_files/folder1/"

var temp:int = 0

func _ready() -> void:
	pass
	
func _process(delta):
	while files_no != file_count(dir_path):
		files_no = file_count(dir_path)
		add_files(files_no)
		print(files_no)
	temp = files_no

func file_count(file_path:String) -> int:
	
	var count = 0
	var dir = DirAccess.open(file_path)
	dir.list_dir_begin()

	while true:
		var f = dir.get_next()
		# if there is no more files found
		if f == "":
			break
		# if the file is not the godot import 
		if not f.contains(".import"):
			count += 1
	dir.list_dir_end()
	return count

func add_files(file_no:int):
	for i in (file_no - temp):
		file = files.instantiate()
		$file_dialog/window/file_container.add_child(file)
		# named file to force automatic naming system = img1, img2 etc
		file.name = "img"
		file._file_name = file.name
		#file_icon = ImageTexture.create_from_image(Image.load_from_file("res://assets/file_dialog/icon-x3.png"))
		file_icon = load("res://assets/file_dialog/icon-x3.png")
		file._file_icon = file_icon
		
		#TODO: change to open in a HxD type window
		file_icon.set_meta("file_name","photo"+str(i)+".jpg")

		# dynamically size the file_container grid seperations 
		$file_dialog/window/file_container.size.x = $file_dialog/window.size.x - (6 * Global.magnification) - 1
		$file_dialog/window/file_container.size.y = $file_dialog/window.size.y - (5 * Global.magnification)
		$file_dialog/window/file_container.position.x = (3 * Global.magnification)
		$file_dialog/window/file_container.position.y = (2 * Global.magnification)
		$file_dialog/window/file_container.add_theme_constant_override("h_separation", file.get_node("select/select_shape").shape.size.x)
		$file_dialog/window/file_container.add_theme_constant_override("v_separation", (file.get_node("select/select_shape").shape.size.y)+(file.get_node("file_name").size.y))
