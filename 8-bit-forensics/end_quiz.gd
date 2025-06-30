extends CanvasLayer

var correct_answer = Global.answers[Global.unlocked]

func _ready() -> void:
	Global.connect("answer", _on_answer_selected)


func _on_a_pressed() -> void:
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 0)

func _on_b_pressed() -> void:
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 1)

func _on_c_pressed() -> void:
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 2)


func _on_answer_selected(day:String, answer:int):
	var given_answer = Global.quiz_dict[day][answer]
	if correct_answer == given_answer:
		$VBoxContainer/answers/result.text = "woo correct"
		$VBoxContainer/answers/exit.visible = true
	else:
		$VBoxContainer/answers/result.text = "try again"


func _on_exit_pressed() -> void:
	Global.unlocked += 1
	get_tree().change_scene_to_file("res://start_menu/menu.tscn")
