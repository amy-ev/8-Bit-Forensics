extends Control
const HOST = "127.0.0.1"
const PORT = 8000
var client = StreamPeerTCP.new()

var evidence_folder:String
func _ready():
	
	if !Global.level_selected:
		evidence_folder = Global.user_path + "evidence_files/"
	else:
		if Global.unlocked == 1:
			evidence_folder = Global.user_path + "evidence_files/"
		elif Global.unlocked == 2:
			evidence_folder = Global.user_path + "metadata_images/"
		else:
			evidence_folder = Global.user_path + "evidence_files/"
			
	print(evidence_folder)
	client.connect_to_host(HOST,PORT)
	client.set_no_delay(true)
	
func _process(delta: float) -> void:
	var status = client.get_status()
	if status != client.STATUS_CONNECTED:
		client.poll()
		print("not connected yet, status: ", status)
	
	client.poll()
	print("status: ", status)
	print("sending file: ", get_parent().selected_file)
	# selected file = the file_name metadata dynamically created
	var selected_img = open_img(evidence_folder+get_parent().selected_file)
	
	send_data(selected_img)
	recv_data()

func open_img(img_path):

	if FileAccess.file_exists(img_path):
		var file = FileAccess.open(img_path, FileAccess.READ)
		var img_data = file.get_buffer(file.get_length())
		return img_data
	else:
		print("failed to open file")
		return
		
func send_data(msg_bytes):
	var file_idx = get_parent().file_idx
	
	var idx_buffer = StreamPeerBuffer.new()
	idx_buffer.big_endian = true
	idx_buffer.put_u32(int(file_idx))
	var idx_msg = idx_buffer.data_array

	var data_buffer = StreamPeerBuffer.new()
	data_buffer.big_endian = true
	data_buffer.put_u32(msg_bytes.size()) # 32-bit unsigned = 4 bytes
	var msg_len = data_buffer.data_array

	client.put_data(idx_msg) # send the files index as 4 bytes
	client.put_data(msg_len) # send the size of the packet as 4 bytes
	client.put_data(msg_bytes) # send the packet

func recv_data():
	while client.get_available_bytes() == 0:
		client.poll()
		
	var response = client.get_data(client.get_available_bytes())
	var byte_array = PackedByteArray(response[1])

	# when response has been recieved disconnect and close client.gd (allow for another instance to be created)
	client.disconnect_from_host()
	queue_free()
	
