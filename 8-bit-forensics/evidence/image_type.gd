extends VBoxContainer

var is_correct:bool
@onready var btn_group = $dd.get_button_group()

func _ready() -> void:
	$dd.grab_focus()
	# have information comparing dd and e01
	for btn in btn_group.get_buttons():
		btn.pressed.connect(func():
			var msg = ""
			match btn.name:
				"dd":
					pass
				"e01":
					pass
			if btn.name == "dd":
				is_correct = true
			else:
				is_correct = false
			print(is_correct)
	)

func _on_cancel_pressed() -> void:
	queue_free()

func _on_back_pressed() -> void:
	get_parent().add_child(load("res://evidence/select_drive.tscn").instantiate())
	queue_free()

func _on_next_pressed() -> void:
	if is_correct:
		get_parent().get_parent().reparent(get_parent().get_parent().get_parent().get_parent().get_node("top_screen"),false)
		get_parent().add_child(load("res://evidence/item_information.tscn").instantiate())
		queue_free()
	else:
		print("nope try again")
