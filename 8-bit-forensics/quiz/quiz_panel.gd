extends PanelContainer

signal exit_pressed()

@onready var quiz = get_parent()
var radio_group = ButtonGroup.new()

func _ready() -> void:
	fill_panel()
	
func fill_panel():
	var quiz_content = open_json("res://quiz/answers.json")
	$sort/question.text = quiz_content[str(Global.unlocked)]["questions"][quiz.current_count]
	
	#dynamic answer creation to allow for a different number of answers per question. with signals still functioning
	for i in Global.answer_options[str(Global.unlocked)][quiz.current_count].size():
		var checkbox:= CheckBox.new()
		checkbox.set_button_group(radio_group)
		checkbox.theme = load("res://assets/UI/pc_components.tres")
		checkbox.text = Global.answer_options[str(Global.unlocked)][quiz.current_count][i] + ") " + quiz_content[str(Global.unlocked)]["answers"][quiz.current_count][i]
		$sort/answers.add_child(checkbox)

		checkbox.name = Global.answer_options[str(Global.unlocked)][quiz.current_count][i]
		checkbox.pressed.connect(_on_button_pressed.bind(checkbox))
	#move finish button to bottom on vbox
	$sort/answers.move_child($sort/answers/exit,-1)

func _on_button_pressed(checkbox:CheckBox):
	quiz.answer_selected = checkbox.name
	Global.answer.emit(Global.answer_options[str(Global.unlocked)][quiz.current_count].find(checkbox.name))
	$sort/answers/exit.set_visible(true)
	$sort/answers/exit.disabled = false
	
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
