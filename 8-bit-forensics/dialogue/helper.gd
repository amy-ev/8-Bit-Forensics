extends CanvasLayer

var help_pressed:bool
var helper_dict:={}
@onready var _dialogue = preload("res://dialogue/dialogue_create_file.tscn")

func _ready() -> void:
	Global.connect("quiz_response", _on_quiz_answered)
	#Global.connect("item_pressed", _on_item_select)
	Global.connect("metadata_help", _on_key_selected)

func _on_key_selected(selected:Node):
	if help_pressed:
		if get_parent().has_node("dialogue_create_file"):
			get_parent().remove_child(get_parent().get_node("dialogue_create_file"))
		var dialogue = _dialogue.instantiate()
		get_parent().add_child(dialogue)
		dialogue.set_visible(true)
		if selected.has_node("metadata_label"):
			var metadata_key = selected.get_node("metadata_label").text
			load_dialogue("res://dialogue/metadata_dialogue.json")
			dialogue.start(helper_dict[metadata_key]["text"])
		#TODO: match case for the selected items and what should be said
		#match selected.name:
			#"evidence_tree_label":
				#dialogue.start("blah blah evidence tree")
		help_pressed = false
		$button.button_pressed = false
		
func _on_button_pressed() -> void:
	help_pressed = true

func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		helper_dict = JSON.parse_string(dialogue.get_as_text())

func _on_quiz_answered(answer:bool):
	if get_parent().has_node("dialogue_answer"):
		get_parent().remove_child(get_parent().get_node("dialogue_answer"))
	var dialogue = preload("res://dialogue/dialogue_answer.tscn").instantiate()
	get_parent().add_child(dialogue)
	if answer:
		dialogue.get_node("wrong").set_visible(false)
		dialogue.get_node("right").set_visible(true)
		dialogue.start("correct !!!")
	else:
		dialogue.get_node("wrong").set_visible(true)
		dialogue.get_node("right").set_visible(false)
		dialogue.start("... incorrect")
