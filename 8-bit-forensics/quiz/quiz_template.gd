extends Control

var questions = []
var answers = []

@export var answer_buttons: ButtonGroup

func _ready() -> void:
	# different questions and answers in the dicts for each level
	pass
	
func _on_confirm_pressed() -> void:
	print(answer_buttons.get_pressed_button().get_parent().get_child(1).text)
