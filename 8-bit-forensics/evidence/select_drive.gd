extends ColorRect

var is_correct:bool
var option_selected:int

@onready var pc = get_parent()

func _ready() -> void:
	Global.emit_signal("next_step",self)
	
	
func _on_back_pressed() -> void:
	pc.add_child(load("res://evidence/select_source.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	Global.emit_signal("answer_response",is_correct)
	if is_correct:
		pc.add_child(preload("res://evidence/image_type.tscn").instantiate())
		queue_free()

func _on_cancel_pressed() -> void:
	queue_free()

func _on_options_item_selected(index: int) -> void:
	option_selected = index
	Global.emit_signal("next_step",self)
	
	if index == 2:
		is_correct = true
	else:
		is_correct = false
