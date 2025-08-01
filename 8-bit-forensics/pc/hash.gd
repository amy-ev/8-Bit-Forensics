extends NinePatchRect

@onready var cmd = $cmd
@onready var hash_output = $output/text


func _ready() -> void:
	if get_parent().has_node("dialogue_display"):
		get_parent().remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	get_parent().add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e6.0")

func _on_submit_pressed() -> void:
	var given_cmd = cmd.text
	var hash_type = ["MD5","SHA1","SHA256","SHA384","SHA512"]
	var output:= []
	var hash:String
	if "certutil -hashfile " in given_cmd:
		for i in len(hash_type):
			if hash_type[i] in given_cmd:

				# to prevent the player from actually writing to the cmd line
				#TODO: change to img file .dd
				OS.execute("cmd.exe", ["/C", "cd %cd%/evidence_files && certutil -hashfile SD-image-file.001 "+hash_type[i]], output)
				$output_type.text = str(hash_type[i], ": ")
				if hash_type[i] == "MD5" || hash_type[i] == "SHA1":

					$done.set_visible(true)
					
		for i in output:
			hash = i.get_slice("\n",1)
		hash_output.text = hash

		queue_redraw()

func _draw() -> void:
	$output.size = hash_output.size + Vector2(4,4)

func _on_done_pressed() -> void:
	Global.emit_signal("hash_verified")
	queue_free()
