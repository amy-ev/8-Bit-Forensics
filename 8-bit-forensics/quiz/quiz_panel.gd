extends PanelContainer

signal exit_pressed()

@onready var quiz = get_parent()

func _ready() -> void:
	fill_panel()
	
func fill_panel():
	$sort/question.text = Global.questions[str(Global.unlocked)][quiz.current_count]
	$sort/answers/a.text = "a) " + Global.answers[str(Global.unlocked)][quiz.current_count][0]
	$sort/answers/b.text = "b) " + Global.answers[str(Global.unlocked)][quiz.current_count][1]
	$sort/answers/c.text = "c) " + Global.answers[str(Global.unlocked)][quiz.current_count][2]
	
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
