extends NinePatchRect

@onready var popup = $file_menu.get_popup()

@onready var pc = get_parent()

var msg = "file1"
var file_created:bool

func _ready() -> void:
	Global.emit_signal("next_step",self)
	Global.connect("create_image_file", _on_file_created)
	
	popup.id_pressed.connect(func(id: int):
		menu_popup(id))

func menu_popup(id):
	if id == 0:
		pc.add_child(preload("res://evidence/select_source.tscn").instantiate())
		
func _on_file_created():
	Global.file_created = true

		#change to match the file contents of the sd card
	var file_1 = $evidence_tree.create_item()
	file_1.set_text(0,msg)
	#TODO: 
	#add dialogue
	# add child of MD5 hash verification 
