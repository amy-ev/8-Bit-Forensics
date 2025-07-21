extends CanvasLayer

func _ready() -> void:
	Global.connect("next_step", _on_new_child)

func _on_new_child(stage:Node):
	
	$panel/dialogue_label.text = ""
	set_visible(false)
	print(stage)
	match stage.name:
		"evidence_file":
				$panel/dialogue_label.start("lets create the image file, just click on the button down below and select 'create disk image'")
				while $panel/dialogue_label.is_playing:
					await get_tree().process_frame
		"select_source":
			match stage.button_pressed:
				#have dialogue that explains what each option means
				
				"physical":
					set_visible(true)
					$panel/dialogue_label.start("physical")
				"logical":
					set_visible(true)
					$panel/dialogue_label.start("logical")
				"image":
					set_visible(true)
					$panel/dialogue_label.start("image")
				"contents":
					set_visible(true)
					$panel/dialogue_label.start("contents")
				"fernico":
					set_visible(true)
					$panel/dialogue_label.start("fernico")
				_:
					pass
		"image_type":
			match stage.button_pressed:
				"dd":
					set_visible(true)
					$panel/dialogue_label.start("dd")
				"e01":
					set_visible(true)
					$panel/dialogue_label.start("e01")
		"item_information":
			set_visible(false)
			stage.get_parent().get_parent().reparent(get_parent(),false)
		"create_file":
			set_visible(false)
			
		"quiz":
			match stage.answer_selected:
				"a":
					$panel/dialogue_label.start(stage.question)
					$panel/dialogue_label.skip()
				"b":
					$panel/dialogue_label.start(stage.question)
					$panel/dialogue_label.skip()
				"c":
					$panel/dialogue_label.start(stage.question)
					$panel/dialogue_label.skip()
		_:
			pass

func _on_ok_pressed() -> void:
	$ok.queue_free()
	$panel/dialogue_label.skip()
