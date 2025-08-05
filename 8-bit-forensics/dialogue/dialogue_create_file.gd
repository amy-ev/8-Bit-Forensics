extends CanvasLayer

@onready var dialogue_label = $panel/dialogue_label
var information_dict:={}

func _ready() -> void:
	set_visible(false)
	load_dialogue("res://dialogue/image_file_dialogue.json")
	Global.connect("next_step", _on_new_child)

func start(dialogue:String):
	dialogue_label.start(dialogue)

func _on_new_child(stage:Node):
	dialogue_label.text = ""
	set_visible(false)

	if stage.name == "select_source" || stage.name == "select_drive" ||stage.name == "image_type":
		if stage.button_pressed == "":
			print("NO")
		else:
			set_visible(true)
			var the_stage = information_dict[stage.name]
			start(the_stage[stage.button_pressed])

		#"item_information":
			#set_visible(true)
			#start("fill in the item information")
		#"create_file":
			#set_visible(true)
			#start("idk press finish")
			#
		#"quiz":
			#match stage.answer_selected:
				#"a":
					#start(stage.question)
					#dialogue_label.skip()
				#"b":
					#start(stage.question)
					#dialogue_label.skip()
				#"c":
					#start(stage.question)
					#dialogue_label.skip()
		#_:
			#set_visible(false)
			#pass

func _on_ok_pressed() -> void:
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		set_visible(false)
		
		
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		information_dict = JSON.parse_string(dialogue.get_as_text())
