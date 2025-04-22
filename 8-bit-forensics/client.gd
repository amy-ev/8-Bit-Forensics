extends Node

const HOST = "127.0.0.1"
const PORT = 8000
var client = StreamPeerTCP.new()
func _ready():
	
	client.connect_to_host(HOST,PORT)
	
	var img_path = "res://example.jpg"
	var file = FileAccess.open(img_path, FileAccess.READ)
	if not file:
		print("failed to open")
		return
		
	var data = file.get_buffer(file.get_length())
	client.poll()
	client.put_data(data)
	print("img sent")

	client.disconnect_from_host()
	
	var output = []
	OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/godot/8-bit-forensics/venv/Scripts/activate.bat"], [])
	#var results = OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/client.py"], output, true,false)
	print(output)
	
