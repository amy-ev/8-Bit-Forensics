extends VBoxContainer

@onready var btn_group = $options/physical.get_button_group()

@export var button_pressed:String

var is_correct:bool

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$options/physical.grab_focus()
	
	for btn in btn_group.get_buttons():
		btn.pressed.connect(func():
			button_pressed = btn.name
			Global.emit_signal("next_step",self)
			
			if btn.name == "physical":
				is_correct = true
			else:
				is_correct = false
			print(is_correct)
		)
		
func _on_next_pressed() -> void:
	Global.emit_signal("answer_response",is_correct)
	if is_correct:
		get_parent().add_child( load("res://evidence/select_drive.tscn").instantiate())
		queue_free()
	else:
		print("nope try again")


func _on_cancel_pressed() -> void:
	queue_free()
