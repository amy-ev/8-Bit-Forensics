extends PanelContainer

signal exit_pressed()

@onready var quiz = get_parent()

func _ready() -> void:
	fill_panel()
	
func fill_panel():
	var quiz_content = open_json("res://quiz/answers.json")
	$sort/question.text = quiz_content[str(Global.unlocked)]["questions"][quiz.current_count]
	
	$sort/answers/a.text = "a) " + quiz_content[str(Global.unlocked)]["answers"][quiz.current_count][0] 
	$sort/answers/b.text = "b) " + quiz_content[str(Global.unlocked)]["answers"][quiz.current_count][1] 
	$sort/answers/c.text = "c) " + quiz_content[str(Global.unlocked)]["answers"][quiz.current_count][2] 
	
func _on_a_pressed() -> void:
	quiz.answer_selected = "a"
	Global.answer.emit(0)

func _on_b_pressed() -> void:
	quiz.answer_selected = "b"
	Global.answer.emit(1)

func _on_c_pressed() -> void:
	quiz.answer_selected = "c"
	Global.answer.emit(2)

func _on_exit_pressed() -> void:
	Global.emit_signal("exit_pressed")

func open_json(file_path):
	if FileAccess.file_exists(file_path):

		var answers = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", answers.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(answers.get_as_text())
		if error == OK:
			var json_dict = json.data
			
			answers.close()
			return json_dict
		else:
			print("error code:" , error)
			answers.close()
