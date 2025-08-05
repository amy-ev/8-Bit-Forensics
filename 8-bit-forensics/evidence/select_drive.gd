extends ColorRect

var is_correct:bool
var button_pressed:String =""

@onready var screen = get_parent()
@onready var pc = screen.get_parent()

func _ready() -> void:
	Global.emit_signal("dialogue_triggered","e5.1")
	
	Global.emit_signal("next_step",self)
	
func _on_back_pressed() -> void:
	screen.add_child(load("res://evidence/select_source.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	Global.emit_signal("answer_response",is_correct)
	if is_correct:
		screen.add_child(preload("res://evidence/image_type.tscn").instantiate())
		queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_options_item_selected(index: int) -> void:
	button_pressed = str(index)
	Global.emit_signal("next_step",self)
	
	if index == 2:
		is_correct = true
	else:
		is_correct = false
