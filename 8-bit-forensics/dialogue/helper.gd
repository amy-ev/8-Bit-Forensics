extends CanvasLayer

var help_pressed:bool
var helper_dict:={}

var parent:Node
var msg:String

var search_dialogue:bool
var select_dialogue:bool

@onready var _dialogue = preload("res://dialogue/dialogue_create_file.tscn")

func _ready() -> void:
	Global.connect("quiz_response", _on_quiz_answered)
	Global.connect("metadata_help", _on_key_selected)
	
	Global.connect("next_step", _on_new_child)

	Global.connect("hex_search_help",search_dialogue_completed)
	Global.connect("hex_select_help",select_dialogue_completed)
	
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
			
		help_pressed = false
		$button.button_pressed = false
		
func _on_button_pressed() -> void:
	help_pressed = true
	print("helper: ",parent.name)
	if parent.name == "hex_viewer":
		if search_dialogue || select_dialogue:
			if get_parent().has_node("dialogue_helper"):
				get_parent().remove_child(get_parent().get_node("dialogue_helper"))
			var dialogue = preload("res://dialogue/dialogue_helper.tscn").instantiate()
			get_parent().add_child(dialogue)
			dialogue.get_node("panel/dialogue_label").start(msg)
	elif parent.name == "hash":
		msg = " certutil -hashfile <filename> HASH \n \n > MD5 \n >SHA1 \n > SHA256 \n > SHA512"
		if get_parent().has_node("dialogue_helper"):
			get_parent().remove_child(get_parent().get_node("dialogue_helper"))
		var dialogue = preload("res://dialogue/dialogue_helper.tscn").instantiate()
		get_parent().add_child(dialogue)
		dialogue.get_node("panel/dialogue_label").start(msg)
	
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		helper_dict = JSON.parse_string(dialogue.get_as_text())

func _on_quiz_answered(answer:bool):
	var quiz = get_parent().get_parent().get_parent()
	if quiz.has_node("dialogue_answer"):
		quiz.remove_child(get_parent().get_node("dialogue_answer"))
	var dialogue = preload("res://dialogue/dialogue_answer.tscn").instantiate()
	quiz.add_child(dialogue)
	
	if answer:
		dialogue.get_node("wrong").set_visible(false)
		dialogue.get_node("right").set_visible(true)
		dialogue.start("correct !!!")
	else:
		dialogue.get_node("wrong").set_visible(true)
		dialogue.get_node("right").set_visible(false)
		dialogue.start("... incorrect")
		
func _on_new_child(stage:Node):
	parent = stage
	if get_parent().has_node("dialogue_helper"):
		get_parent().remove_child(get_parent().get_node("dialogue_helper"))
	
	if parent.name == "hex_viewer" || parent.name == "hash":
		$button.toggle_mode = false
	
func search_dialogue_completed():
	search_dialogue = true
	msg = " > Ctrl-F \n > FF D8 FF E0 \n > FF D9"

func select_dialogue_completed():
	select_dialogue = true
	msg = " > Ctrl-E \n > FF D8 FF E0 \n > FF D9"
