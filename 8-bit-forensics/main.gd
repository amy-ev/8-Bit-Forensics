extends Node


func _ready() -> void:
	var output = []
	OS.execute("C:/Users/Amy/Desktop/8-Bit-Forensics/HxD.exe",[],output)
	
