extends TextureRect

func _ready() -> void:
	Global.connect("next_step", _on_new_child)
	Global.connect("answer_response", _on_option_confirmed)
	
func _on_new_child(stage:Node):
	$answer_panel.set_visible(false)
	$bad.set_visible(false)
	
	$panel/dialogue_label.text = ""
	
	set_visible(true)
	print(stage)
	match stage.name:
		"evidence_file":
					$panel/dialogue_label.start("lets create the image file, just click on the button down below and select 'create disk image'")
		"select_source":
			match stage.button_pressed:
				#have dialogue that explains what each option means
				"physical":
					$panel/dialogue_label.start("physical")
				"logical":
					$panel/dialogue_label.start("logical")
				"image":
					$panel/dialogue_label.start("image")
				"contents":
					$panel/dialogue_label.start("contents")
				"fernico":
					$panel/dialogue_label.start("fernico")
				_:
					pass
		"image_type":
			match stage.button_pressed:
				"dd":
					$panel/dialogue_label.start("dd")
				"e01":
					$panel/dialogue_label.start("e01")
		"item_information":
			stage.get_parent().get_parent().reparent(get_parent(),false)
		"create_file":
			set_visible(false)
			stage.get_parent().get_parent().reparent(get_parent().get_parent().get_node("bottom_screen"),false)
		_:
			pass

func _on_option_confirmed(is_correct:bool):
	if is_correct:
		$bad.set_visible(false)
		$answer_panel.set_visible(false)
	else:
		$bad.set_visible(true)
		$answer_panel.set_visible(true)
		$answer_panel/dialogue_label.start("that is not correct")
	
