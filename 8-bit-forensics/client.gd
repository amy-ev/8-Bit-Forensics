extends Node

const HOST = "127.0.0.1"
const PORT = 8000
var client = StreamPeerTCP.new()

func _ready():
	
	client.connect_to_host(HOST,PORT)
	
	var file = open_img("example.jpg")
	#print(OS.get_executable_path().get_base_dir().path_join("example.jpg"))
	#print(ProjectSettings.globalize_path("res://example.jpg"))
	send_data(client,file)
	#if response != null:
		#print(response.get_string_from_utf8())
	#else:
		#print("no response")
	#client.disconnect_from_host()
	#print(recv_msg(client))
	
func open_img(img_path):
	if FileAccess.file_exists(img_path):
		var file = FileAccess.open(img_path, FileAccess.READ)
		return file
	else:
		print("failed to open file")
		return
	
func send_data(socket, file):
	var packet_size = file.get_length()
	var data = file.get_buffer(packet_size)
	
	var buffer = PackedByteArray()
	buffer.resize(4)
	buffer.encode_u32(0, packet_size)
	
	var packet = buffer + data
	socket.poll()
	socket.put_data(packet)

	client.disconnect_from_host()
	print("img sent")

func recv_msg(socket):
	var msg_len = recv_data(socket,4)
	if msg_len.size() != 4:
		return null
	msg_len = msg_len.decode_u32(0)
	return recv_data(socket, msg_len)
	
func recv_data(socket, num_bytes):
	var data = PackedByteArray()
	print(num_bytes)
	while data.size() < num_bytes:
		var remaining = num_bytes - data.size()
		print(remaining)
		var data_status = socket.get_data(remaining)
		if data_status[0] != OK:
			break
		var packet = data_status[1]
		if packet.size() == 0:
			break
		data.append_array(packet)
		print("the data:", data)
	return data
		
		
		
	#var output = []
	#OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/godot/8-bit-forensics/venv/Scripts/activate.bat"], [])
	##var results = OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/client.py"], output, true,false)
	#print(output)
	
