extends Node

const HOST = "127.0.0.1"
const PORT = 8000
var client = StreamPeerTCP.new()


func _ready():
	client.connect_to_host(HOST,PORT)
	client.set_no_delay(true)
	
func _process(delta: float) -> void:
	var status = client.get_status()
	if status != client.STATUS_CONNECTED:
		client.poll()
		print("not connected yet, status: ", status)
	#print(status)
	var file = open_img("example.jpg")
	var data = send_data(client,file)
	print(client.get_available_bytes())
	if client.get_available_bytes():
		var response = client.get_data(client.get_available_bytes())
		print("recieved the fucking response: ", response)
		
		
	#var response = recv_data(client)
	#print(response.get_string_from_utf8())
	
func open_img(img_path):
	#print(OS.get_executable_path().get_base_dir().path_join("example.jpg"))
	#print(ProjectSettings.globalize_path("res://example.jpg"))
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
	
	print("img sent")

func recv_msg(socket):
	pass
	#var msg_len = recv_data(socket,4)
	#if msg_len.size() != 4:
		#return null
	#msg_len = msg_len.decode_u32(0)
	#return recv_data(socket, msg_len)
	#
	#num_bytes
func recv_data(socket):
	var header = socket.get_data(4)
	var msg_len = header.decode_u32(0)
	
	var data = PackedByteArray()
	while data.size() < msg_len:
		var packet = socket.get_data(4096)
		print(packet)
		if not data:
			break
		data.append(packet)
	return data
	#print(num_bytes)
	#while data.size() < num_bytes:
		#var remaining = num_bytes - data.size()
		#print(remaining)
		#var data_status = socket.get_data(remaining)
		#if data_status[0] != OK:
			#break
		#var packet = data_status[1]
		#if packet.size() == 0:
			#break
		#data.append_array(packet)
		#print("the data:", data)
	#return data
		
		
		
	#var output = []
	#OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/godot/8-bit-forensics/venv/Scripts/activate.bat"], [])
	##var results = OS.execute("CMD.exe",["/C", "python C:/Users/Amy/Desktop/8-Bit-Forensics/client.py"], output, true,false)
	#print(output)
	
