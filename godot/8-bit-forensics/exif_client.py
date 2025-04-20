from py4godot.classes import gdclass
from py4godot.classes.Node import Node

import sys 
import os

#direct to virtual environment 
venv_path = os.path.join(os.getcwd(),"venv","Lib","site-packages")
if venv_path not in sys.path:
	sys.path.append(venv_path)

import socket

@gdclass
class exif_client(Node):
	def _ready(self):
		client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

		server_ip = "127.0.0.1"
		server_port = 8000

		client.connect((server_ip, server_port))

		while True:
			file_name = 'example.jpg'
			try:
				f_input = open(file_name, 'rb') 
				data = f_input.read(1024) 
				if not data:
					break
				while data:
					client.send(data)
					data = f_input.read(1024)
				f_input.close()
				break

			except IOError:
				print("invalid filename!\
				Please enter a valid name")
		client.close()
