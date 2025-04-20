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
class client(Node):

	def _ready(self):
		self.run_client()
		
	def run_client(self):
		client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		server_ip = "127.0.0.1"
		server_port = 8000
		
		client.connect((server_ip, server_port))
		
		msg = open("example.jpg",'rb')
		img_packet = msg.read(1024)
		
		while (img_packet):
			client.send(img_packet)
			img_packet = msg.read(1024)
			
			response = client.recv(1024)
			response = response.decode("utf-8")
			
			if response.lower() == "closed":
				break
			#print(f"recieved: {response}")
		client.shutdown(socket.SHUT_WR)
		client.close()
		print("connection to server closed")
		
