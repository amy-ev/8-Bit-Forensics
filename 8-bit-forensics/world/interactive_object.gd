extends Node2D

@onready var _file_dialog = preload("res://file_dialog/load_file.tscn")
	
func _ready() -> void:
	Global.connect("computer",_computer_on)
	
func _on_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.computer.emit(true)
		
func _computer_on(on:bool):
	print(Global.already_on)
	if on == true:
		if Global.already_on == false:
			var file_dialog =  _file_dialog.instantiate()
			get_parent().add_child(file_dialog)
			get_parent().get_node("load_file").position = Vector2(300,300)
			
			Global.already_on = true	
