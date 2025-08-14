extends NinePatchRect

@onready var cmd = $cmd
@onready var pc = get_parent().get_parent()

var thread: Thread
func _ready() -> void:

	Global.emit_signal("dialogue_triggered","e6.0")
	Global.emit_signal("next_step",self)

func _on_submit_pressed() -> void:
	thread = Thread.new()
	var h_output = preload("res://pc/level1/output.tscn").instantiate()
	var given_cmd = cmd.text
	var hash_type = ["MD5","SHA1","SHA256","SHA384","SHA512"]
	var output:= []
	var hash:String
	if get_parent().has_node("output"):
		get_parent().remove_child(get_parent().get_node("output"))
	get_parent().add_child(h_output)
	
	thread.start(_thread.bind(given_cmd))
	
	while thread.is_alive():
		await get_tree().process_frame
	hash = thread.wait_to_finish()
	thread = null
	
	if "certutil -hashfile " in given_cmd:
		for i in len(hash_type):
			if hash_type[i] in given_cmd:
				h_output.get_node("output_type").text = str(hash_type[i], ": ")
				if hash_type[i] == "MD5" || hash_type[i] == "SHA1":
					$done.set_visible(true)
					h_output.get_node("output_type").text = str(hash_type[i], ": ")
				
		h_output.get_node("text").text = hash
		queue_redraw()
	else:
		Global.emit_signal("answer_response",false)
		
func _thread(given_cmd:String) -> String:
	var output = []
	var hash:=""
	var hash_type = ["MD5","SHA1","SHA256","SHA384","SHA512"]
	if "certutil -hashfile " in given_cmd:
		for i in len(hash_type):
			if hash_type[i] in given_cmd:
				
				# to prevent the player from actually writing to the cmd line
				var err:int = OS.execute("cmd.exe", ["/C", "cd " +Global.user_path +"evidence_files && certutil -hashfile SD-image-file.001 "+hash_type[i]], output, true)

				if err != 0:
					printerr("error: %d"%err)
	for i in output:
		hash = i.get_slice("\n",1)
		
	return hash
	
func _on_done_pressed() -> void:
	Global.hash_verified = true
	pc.get_node("back_btn").set_visible(true)
	pc.get_node("screen/helper").queue_free()
	Global.emit_signal("dialogue_triggered","e7.0")
	get_parent().remove_child(get_parent().get_node("output"))
	queue_free()
