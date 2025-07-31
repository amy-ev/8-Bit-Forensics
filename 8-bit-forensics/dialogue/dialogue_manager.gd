extends CanvasLayer

var desk_dialogue = "res://dialogue/debrief_dialogue.json"
var pc_dialogue = "res://dialogue/pc_dialogue.json"

@export var desk_debrief = {}
var pc_debrief = {}
var current_dialogue = ""
@export var option:String
var own_response:bool
var display_options:= [0,0]
@onready var dialogue_label = $panel/container/dialogue_label

signal end_dialogue

func _ready() -> void:
	Global.connect("text_finished", _on_text_finished)
	desk_debrief = load_dialogue(desk_dialogue)
	pc_debrief = load_dialogue(pc_dialogue)

	$panel/container/name.text = "Chief Quacky McQuackFace"
	show_options(display_options)
	
	match get_parent().name:
		"desk":
			dialogue_text(desk_debrief,"Day %s.0" %(Global.unlocked+1))
		"pc":
			dialogue_text(pc_debrief,"Day %s.0"%(Global.unlocked+1))
	
	self.connect("end_dialogue", _end_dialogue)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("enter"):
		dialogue_label.skip()
		
# insert json text to the dialogue box
func dialogue_text(dict,_option):
	display_options = [0,0]
	show_options(display_options)
	dialogue_label.start(dict[_option]["text"])
	current_dialogue = _option

func _end_dialogue():
	match get_parent().name:
		"desk":
			Global.debrief_given = true
		"pc":
			Global.pc_debrief_given = true

	queue_free()
	
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		return JSON.parse_string(dialogue.get_as_text())

func next_dialogue(dict):

	if dict[current_dialogue].has("go to"):
		var next = dict[current_dialogue]["go to"][0]
		
		if own_response:
			$panel/container/name.text = "Rookie"
			display_options = [0,0]
			dialogue_text(dict, dict[current_dialogue]["go to"][0]) 
			own_response = false
			
		print("current: ", current_dialogue, " next: ", next)
		if dict[current_dialogue].has("go to") && dict[current_dialogue]["go to"].size() > 1:
		#if dict[next].has("go to") && dict[next]["go to"].size() > 1:
			var option_a = dict[current_dialogue]["go to"][0]
			var a_text = dict[option_a]["option display"]
			
			var option_b = dict[current_dialogue]["go to"][1]
			var b_text = dict[option_b]["option display"]
			
			print("option a: ", option_a, " option b: ", option_b)
			
			if a_text == b_text:
				display_options = [1,0]
			else:
				display_options = [1,1]

			$option_a/label.text = a_text
			$option_b/label.text = b_text
			
		else:
			display_options = [1,0]
			$option_a/label.text = "NEXT"


	else:
		display_options = [1,0]
		
	show_options(display_options)

func show_options(_options_visible):
	if _options_visible[0] == 1:
		$option_a.set_visible(true)
	else:
		$option_a.set_visible(false)
	if _options_visible[1] == 1:
		$option_b.set_visible(true)
	else:
		$option_b.set_visible(false)
		
func response_dialogue(dict):
	if dict[current_dialogue].has("go to"):
		if dict[current_dialogue]["go to"].size() > 1:
			own_response = true
			$panel/container/name.text = "Rookie"
			if option.ends_with("a"):
				dialogue_text(dict, dict[current_dialogue]["go to"][0]) 
			elif option.ends_with("b"):
				dialogue_text(dict, dict[current_dialogue]["go to"][1]) 
			own_response = false
		else:
			own_response = false
			$panel/container/name.text = "Chief Quacky McQuackFace"
			dialogue_text(dict, dict[current_dialogue]["go to"][0]) 
	else:
		$panel/container/name.text = "Chief Quacky McQuackFace"
		emit_signal(dict[current_dialogue]["function"])
		

func _on_select_option_selected(_option: String) -> void:
	option = _option
	match get_parent().name:
		"desk":
			response_dialogue(desk_debrief)
		"pc":
			pass

func _on_text_finished():
	
	match get_parent().name:
		"desk":
			next_dialogue(desk_debrief)
		"pc":
			pass
	
