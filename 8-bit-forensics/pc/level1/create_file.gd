extends ColorRect

@export var files = []

@onready var screen = get_parent()
@onready var pc = screen.get_parent()

#TODO: PRODUCE A MD5 HASH
var thread: Thread
func _ready() -> void:
	thread = Thread.new()
	Global.connect("inc_progressbar", inc_progress)
	screen.get_node("evidence_file").get_node("file_menu").disabled = true
	Global.emit_signal("dialogue_triggered","e5.4")
	Global.emit_signal("next_step",self)
	
	thread.start(_thread)
	
	while thread.is_alive():
		await get_tree().process_frame
	Global.hash_array = thread.wait_to_finish()
	thread = null

func _thread() -> Array:
	var output = []
	var MD5_hash:=""
	var SHA1_hash:=""
	
	var err: int = OS.execute("cmd.exe", ["/C", "cd " + Global.user_path+"evidence_files && certutil -hashfile SD-image-file.001 MD5"], output, true)
	if err != 0:
		printerr("error: %d"%err)
	for i in output:
		MD5_hash = i.get_slice("\n",1)
		
	err = OS.execute("cmd.exe", ["/C", "cd " + Global.user_path+"evidence_files && certutil -hashfile SD-image-file.001 SHA1"], output, true)
	if err != 0:
		printerr("error: %d"%err)
	for i in output:
		SHA1_hash = i.get_slice("\n",1)
		
	return [MD5_hash, SHA1_hash]
	
func _on_next_pressed() -> void:
	screen.add_child(preload("res://pc/level1//hash.tscn").instantiate())
	
	Global.emit_signal("create_image_file")
	Global.file_created = true
	queue_free()

func inc_progress():
	var current = $window/progress.value
	var target = current + (float(100.0/5.0))
	
	var tween = get_tree().create_tween()
	tween.tween_property($window/progress,"value",target,1.0)
