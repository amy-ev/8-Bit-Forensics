extends Node2D

@onready var _file_dialog = preload("res://computer_screen/computer_screen.tscn")
#@onready var _file_dialog = preload("res://computer_screen/file_dialog/load_file.tscn")

func _ready() -> void:
	Global.connect("computer",_computer_on)
	get_node("hitbox/hitbox_shape").shape.size = get_node("object_sprite").texture.get_size()
	
func _on_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.computer.emit(true)
		
func _computer_on(on:bool):
	print(Global.already_on)
	if on == true:
		if Global.already_on == false:
			var file_dialog =  _file_dialog.instantiate()
			get_parent().add_child(file_dialog)
			get_parent().get_node("computer_screen/load_file").position = Vector2(30,30)
			
			Global.already_on = true	
