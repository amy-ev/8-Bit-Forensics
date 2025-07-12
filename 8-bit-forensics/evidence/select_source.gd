extends VBoxContainer

@onready var btn_group = $options/physical.get_button_group()
var is_correct:bool

func _ready() -> void:
	for btn in btn_group.get_buttons():
		btn.pressed.connect(func():
			var msg = ""
			match btn.name:
				#have dialogue that explains what each option means
				"physical":
					msg = "correct"
				"logical":
					msg = "no"
				"image":
					msg = "no"
				"contents":
					msg = "no"
				"fernico":
					msg = "no"
				_:
					msg = "idk"
			if btn.name == "physical":
				is_correct = true
			else:
				is_correct = false
			print(is_correct)
		)
		
func _on_next_pressed() -> void:
	if is_correct:
		get_parent().add_child(load("res://evidence/select_drive.tscn").instantiate())
		queue_free()
	else:
		print("nope try again")


func _on_cancel_pressed() -> void:
	queue_free()
