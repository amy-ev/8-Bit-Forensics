import sys 
import os
import socket
import struct

# #direct to virtual environment 
# venv_path = os.path.join(os.getcwd(),"venv","Lib","site-packages")
# if venv_path not in sys.path:
# 	sys.path.append(venv_path)

def _ready():
	host = '127.0.0.1'
	port = 8000
		
	client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	client.connect((host,port))

	print("in client script")
	client.close()

_ready()
