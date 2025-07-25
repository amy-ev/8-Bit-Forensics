extends NinePatchRect

@onready var cmd = $cmd
@onready var hash_output = $output/text

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
				OS.execute("cmd.exe", ["/C", "cd %cd%/jpg_folder && certutil -hashfile photo2.jpg "+hash_type[i]], output)
				$output_type.text = str(hash_type[i], ": ")
		for i in output:
			hash = i.get_slice("\n",1)
		print(hash)
		hash_output.text = hash

		queue_redraw()

func _draw() -> void:
	$output.size = hash_output.size + Vector2(4,4)
