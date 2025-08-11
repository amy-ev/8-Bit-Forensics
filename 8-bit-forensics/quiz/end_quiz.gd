extends Node2D

var answer_selected
var question_count:int
var current_count:int

var correct_answer = Global.answer_options[str(Global.unlocked)][current_count][Global.answer_options[str(Global.unlocked)][current_count].find(Global.correct_answers[Global.unlocked][current_count])]
var given_answer
var question:String = "this is the question"

func _ready() -> void:
	Global.connect("answer", _on_answer_selected)

	scale = scale * Utility.window_mode()
	
	question_count = Global.questions[str(Global.unlocked)].size()
	add_child(preload("res://quiz/quiz_panel.tscn").instantiate(),true)
	Global.connect("exit_pressed", _on_exit_pressed)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)


func _on_answer_selected(answer:int):
	given_answer =  Global.answer_options[str(Global.unlocked)][current_count][answer]
	
	var panel = get_child(0).get_node("sort/answers/exit")
	panel.visible = true
	panel.disabled = false

func _on_exit_pressed() -> void:
	var panel = get_child(0).get_node("sort/answers/exit")
	panel.disabled = true
	panel.release_focus()
	if correct_answer == given_answer:
		Global.emit_signal("quiz_response",true)
		current_count += 1
		
		if current_count == question_count:
			
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
			
			get_tree().change_scene_to_file("res://main/main.tscn")
		else: 
			get_node("panel").queue_free()
			await get_node("panel").tree_exited
			add_child(preload("res://quiz/quiz_panel.tscn").instantiate(),true)
			correct_answer = Global.answer_options[str(Global.unlocked)][current_count][Global.answer_options[str(Global.unlocked)][current_count].find(Global.correct_answers[Global.unlocked][current_count])]
	else:
		Global.emit_signal("quiz_response",false)
