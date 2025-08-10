extends NinePatchRect

@onready var cmd = $cmd
@onready var pc = get_parent().get_parent()


func _ready() -> void:
	Global.emit_signal("dialogue_triggered","e6.0")
	Global.emit_signal("next_step",self)

func _on_submit_pressed() -> void:
	var h_output = preload("res://pc/output.tscn").instantiate()
	var given_cmd = cmd.text
	var hash_type = ["MD5","SHA1","SHA256","SHA384","SHA512"]
	var output:= []
	var hash:String
	if get_parent().has_node("output"):
		get_parent().remove_child(get_parent().get_node("output"))
	get_parent().add_child(h_output)
	
	if "certutil -hashfile " in given_cmd:
		for i in len(hash_type):
			if hash_type[i] in given_cmd:
				
				# to prevent the player from actually writing to the cmd line
				OS.execute("cmd.exe", ["/C", "cd %cd%/evidence_files && certutil -hashfile SD-image-file.001 "+hash_type[i]], output)
				h_output.get_node("output_type").text = str(hash_type[i], ": ")
				if hash_type[i] == "MD5" || hash_type[i] == "SHA1":
					$done.set_visible(true)
					
		for i in output:
			hash = i.get_slice("\n",1)

		h_output.get_node("text").text = hash
		queue_redraw()
	else:
		Global.emit_signal("answer_response",false)

func _on_done_pressed() -> void:
	Global.hash_verified = true
	Global.emit_signal("dialogue_triggered","e7.0")
	get_parent().remove_child(get_parent().get_node("output"))
	queue_free()
