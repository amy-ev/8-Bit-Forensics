extends NinePatchRect

@onready var btn_group = $sort/dd.get_button_group()
@onready var pc = get_parent()

var button_pressed:String
var is_correct:bool

func _ready() -> void:
	$sort/dd.grab_focus()
	Global.emit_signal("next_step",self)
	# have information comparing dd and e01
	for btn in btn_group.get_buttons():
		btn.pressed.connect(func():
			button_pressed = btn.name
			Global.emit_signal("next_step",self)
			
			if btn.name == "dd":
				is_correct = true
			else:
				is_correct = false
			print(is_correct)
	)

func _on_cancel_pressed() -> void:
	queue_free()

func _on_back_pressed() -> void:
	pc.add_child(load("res://evidence/select_drive.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	Global.emit_signal("answer_response",is_correct)
	if is_correct:
		pc.add_child(load("res://evidence/item_information.tscn").instantiate())
		queue_free()
	else:
		print("nope try again")
