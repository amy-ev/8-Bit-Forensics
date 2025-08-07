extends Node2D

var correct_answer = Global.answers[Global.unlocked]
var given_answer
var question:String = "this is the question"

var answer_selected

func _ready() -> void:

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

	$panel/sort/answers/exit.visible = true
	$panel/sort/answers/exit.disabled = false

func _on_exit_pressed() -> void:
	$panel/sort/answers/exit.disabled = true
	$panel/sort/answers/exit.release_focus()
	if correct_answer == given_answer:
		Global.emit_signal("quiz_response",true)
		
		#to prevent repeating a level and infinitely increasing unlocked
		if !Global.level_selected:
			if Global.unlocked == 0:
				Global.unlocked = 1
			elif Global.unlocked == 1:
				Global.unlocked = 2
			elif Global.unlocked == 2:
				Global.unlocked = 3
			else:
				Global.unlocked = Global.unlocked
				
			Global.set_save(Global.user_path + "savefile.json")
		else:
			Global.unlocked = int(Global.get_save(Global.user_path+"savefile.json"))
			
		if has_node("dialogue_answer"):
			var response_dialogue = $dialogue_answer
			await response_dialogue.tree_exited
		
		#TODO: change to have multiple questions 
		get_tree().change_scene_to_file("res://main/main.tscn")
	else:
		Global.emit_signal("quiz_response",false)
