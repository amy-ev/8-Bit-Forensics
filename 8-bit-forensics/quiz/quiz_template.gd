extends Control

var questions = []
var answers = []

@export var answer_buttons: ButtonGroup

func _ready() -> void:
	# different questions and answers in the dicts for each level
	pass
	
func _on_confirm_pressed() -> void:
	check_answer()


func check_answer() -> bool:
	var answer:String = answer_buttons.get_pressed_button().get_parent().get_child(1).text
	var correct_answer:String = "yes"
	if answer == correct_answer:
		return true
	return false
