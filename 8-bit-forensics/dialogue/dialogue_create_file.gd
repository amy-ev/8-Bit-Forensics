extends CanvasLayer

@onready var dialogue_label = $panel/dialogue_label

func _ready() -> void:
	set_visible(false)
	Global.connect("next_step", _on_new_child)

func start(dialogue:String):
	dialogue_label.start(dialogue)
	
func _on_new_child(stage:Node):
	
	dialogue_label.text = ""
	set_visible(false)
	
	match stage.name:
		"select_source":
			match stage.button_pressed:
				#have dialogue that explains what each option means
				"physical":
					set_visible(true)
					start("physical")
				"logical":
					set_visible(true)
					start("logical")
				"image":
					set_visible(true)
					start("image")
				"contents":
					set_visible(true)
					start("contents")
				"fernico":
					set_visible(true)
					start("fernico")
				_:
					set_visible(false)
		"select_drive":
			match stage.option_selected:
				0:
					set_visible(true)
					start("index 0")
				1:
					set_visible(true)
					start("index 1")
				2:
					set_visible(true)
					start("index 2")
		"image_type":
			match stage.button_pressed:
				"dd":
					set_visible(true)
					start("dd")
				"e01":
					set_visible(true)
					start("e01")
	
		"item_information":
			set_visible(true)
			start("fill in the item information")
		"create_file":
			set_visible(true)
			start("idk press finish")
			
		"quiz":
			match stage.answer_selected:
				"a":
					start(stage.question)
					dialogue_label.skip()
				"b":
					start(stage.question)
					dialogue_label.skip()
				"c":
					start(stage.question)
					dialogue_label.skip()
		_:
			set_visible(false)
			pass

func _on_ok_pressed() -> void:
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		set_visible(false)
