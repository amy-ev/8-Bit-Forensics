extends Node2D

var correct_answer = Global.answers[Global.unlocked]
var given_answer
var question:String = "this is the question"

var answer_selected

func _ready() -> void:
	Global.emit_signal("next_step",self)
	Global.connect("answer", _on_answer_selected)
	scale = scale * Utility.window_mode()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_a_pressed() -> void:
	answer_selected = "a"
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 0)

func _on_b_pressed() -> void:
	answer_selected = "b"
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 1)

func _on_c_pressed() -> void:
	answer_selected = "c"
	Global.answer.emit("Day_"+ str(Global.unlocked +1), 2)


func _on_answer_selected(day:String, answer:int):
	given_answer = Global.quiz_dict[day][answer]
	Global.emit_signal("next_step",self)
	$bottom_screen/answers/exit.visible = true
	$bottom_screen/answers/exit.disabled = false

func _on_exit_pressed() -> void:
	if correct_answer == given_answer:
		Global.emit_signal("answer_response",true)
		Global.unlocked += 1
		get_tree().change_scene_to_file("res://main/main.tscn")
	else:
		Global.emit_signal("answer_response",false)
