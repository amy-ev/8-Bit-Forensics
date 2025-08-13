extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()
	#pointing to the user:// directory
	var dest_path = Global.user_path 
	
	var save_file_path = "res://savefile.json"
	if FileAccess.file_exists(save_file_path):
		var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	
		var content = save_file.get_buffer(save_file.get_length())
		save_file.close()
		
		var dest_file_path = Global.user_path + save_file_path.substr(6,-1)
		if !FileAccess.file_exists(dest_file_path):
			var dest_file = FileAccess.open(dest_file_path, FileAccess.WRITE)

			dest_file.store_buffer(content)
			dest_file.close()
	
	var source_folders = [
		"res://evidence_files",
		"res://python_files",
		"res://metadata_images"
	]
	
	for source in source_folders:
		var source_name = source.substr(6,-1)
		#recursively add every file and subfolder files to the destination directory (user://)
		create_user_files(source,dest_path+source_name)

	if !FileAccess.file_exists(Global.user_path + "metadata_images/image1.jpg") || !FileAccess.file_exists(Global.user_path + "metadata_images/image2.jpg") || !FileAccess.file_exists(Global.user_path + "metadata_images/image3.jpg") || !FileAccess.file_exists(Global.user_path + "metadata_images/image4.jpg"):
		Global.create_images()
		
		#to prevent issues selecting a level and then returning to the main menu
	Global.unlocked = int(Global.get_save(Global.user_path +"savefile.json"))


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)


func create_user_files(source_path:String, dest_path:String):
	var source_dir = DirAccess.open(source_path)
	if source_dir == null:
		print("cannot access source dir")
		return false
	
	var err:= DirAccess.make_dir_recursive_absolute(dest_path)
	if err != OK:
		print("cannot create dir")
		return false
	
	var has_content = false
	
	source_dir.list_dir_begin()
	var file_name = source_dir.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = source_dir.get_next()
			continue
			
		#include empty folders
		has_content = true
		var source_file_path = source_path.path_join(file_name)
		var dest_file_path = dest_path.path_join(file_name)
		
		#for subfolders
		if source_dir.current_is_dir():
			if not create_user_files(source_file_path,dest_file_path):
				return false
		else:
			if not copy_files(source_file_path,dest_file_path):
				return false
		file_name = source_dir.get_next()
	source_dir.list_dir_end()

	return true
	
func copy_files(source_path:String, dest_path:String):
	#if it already exists then skip
	if FileAccess.file_exists(dest_path):
		return true
	var source_file = FileAccess.open(source_path, FileAccess.READ)
	
	var file_buffer = source_file.get_buffer(source_file.get_length())
	source_file.close()
	
	var dest_dir = dest_path.get_base_dir()
	
	var err = DirAccess.make_dir_recursive_absolute(dest_dir)
	if err != OK:
		return false
		
	var dest_file = FileAccess.open(dest_path, FileAccess.WRITE)
	if dest_file == null:
		return false
		
	dest_file.store_buffer(file_buffer)
	dest_file.close()
	return true
