from py4godot.classes import gdclass
from py4godot.classes.Node import Node

import sys 
import os

#direct to virtual environment 
venv_path = os.path.join(os.getcwd(),"venv","Lib","site-packages")
if venv_path not in sys.path:
	sys.path.append(venv_path)

import socket
import struct

@gdclass
class test_client(Node):
	def _ready(self):
		host = '127.0.0.1'
		port = 8000
		with open('example.jpg','rb') as img_f:
			img_data = img_f.read()
			
		client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		client.connect((host,port))
		
		client.sendall(struct.pack('!I', len(img_data)))
		client.sendall(img_data)
		print(f"sent image")
		# -- SERVER RESPONSE --
		b_size = client.recv(4)
		response_len = struct.unpack('!I', b_size)[0]
		response_data = b''
		while len(response_data) < response_len:
			data = client.recv(4096)
			if not data:
				break
			response_data += data
		response_str = response_data.decode('utf-8')
		print("recieved data")
		with open('response.txt','w') as fo:
			fo.write(response_str)
		print("response saved to txt")
		
		client.close()
		
