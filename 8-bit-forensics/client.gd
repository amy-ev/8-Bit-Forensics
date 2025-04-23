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
		
	client.poll()
	
	print("status: ", status)
	# --- send data ---
	#var msg = "hello"
	#var msg_bytes = msg.to_utf8_buffer()
	
	var msg_bytes = open_img("res://example.jpg")
	send_data(msg_bytes)
	recv_data()
	# --- receive data ---
		
func open_img(img_path):
	#print(OS.get_executable_path().get_base_dir().path_join("example.jpg"))
	#print(ProjectSettings.globalize_path("res://example.jpg"))
	if FileAccess.file_exists(img_path):
		var file = FileAccess.open(img_path, FileAccess.READ)
		var img_data = file.get_buffer(file.get_length())
		return img_data
	else:
		print("failed to open file")
		return
		
func send_data(msg_bytes):
	print(msg_bytes.size())

	var data_buffer = StreamPeerBuffer.new()
	data_buffer.big_endian = true
	data_buffer.put_u32(msg_bytes.size()) # 32-bit unsigned = 4 bytes
	
	var msg_len = data_buffer.data_array
	client.put_data(msg_len) # send the size of the packet a 4 bytes
	client.put_data(msg_bytes) # send the packet

func recv_data():
	if client.get_available_bytes() != 0:

		var response = client.get_utf8_string(client.get_available_bytes())
		print(response)
		client.disconnect_from_host()
		queue_free()
	else:
		client.poll()
		
