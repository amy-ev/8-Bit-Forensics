from py4godot.classes import gdclass
from py4godot.classes.Node2D import Node2D

import sys 
import os

#direct to virtual environment 
venv_path = os.path.join(os.getcwd(),"venv","Lib","site-packages")
if venv_path not in sys.path:
	sys.path.append(venv_path)

import requests

@gdclass
class test(Node2D): #class name must match file name - CASE SENSITIVE
	def _ready(self):
		response = requests.get("https://pokeapi.co/api/v2/pokemon/ditto")
		print(response.json())
