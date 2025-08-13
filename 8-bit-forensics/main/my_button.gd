extends Button
class_name MyButton

func _ready() -> void:
	#theme = preload("res://assets/UI/pc_components.tres")
	add_to_group("buttons")
	
func _on_mouse_entered() -> void:
	audio.select.play(0.04)
