extends ColorRect

@onready var btn_group = $window/sort/dd.get_button_group()
@onready var screen = get_parent()

var button_pressed:String
var is_correct:bool

func _ready() -> void:
	Global.emit_signal("dialogue_triggered","e5.2")

	Global.emit_signal("next_step",self)
	# have information comparing dd and e01
	for btn in btn_group.get_buttons():
		btn.pressed.connect(func():
			button_pressed = btn.name
			Global.emit_signal("next_step",self)
			
			if btn.name == "dd":
				is_correct = true
				button_pressed = ""
			else:
				is_correct = false
				button_pressed = ""
	)

func _on_cancel_pressed() -> void:
	queue_free()

func _on_back_pressed() -> void:
	screen.add_child(load("res://evidence/select_drive.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	Global.emit_signal("answer_response",is_correct)
	if is_correct:
		screen.add_child(preload("res://evidence/item_information.tscn").instantiate())
		queue_free()
