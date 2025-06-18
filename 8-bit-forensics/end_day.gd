extends TextureRect

@onready var _quiz = preload("res://quiz.tscn")

func _on_exit_pressed() -> void:
	var quiz = _quiz.instantiate()
	get_parent().add_child(quiz)
	queue_free()
