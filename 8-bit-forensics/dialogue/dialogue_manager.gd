extends CanvasLayer

var desk_dialogue = "res://dialogue/desk_dialogue.json"
var pc_dialogue = "res://dialogue/pc_dialogue.json"

@export var desk_debrief = {}
var pc_debrief = {}
@export var current_dialogue = ""

@onready var dialogue_label = $panel/container/dialogue_label

signal end_dialogue

func _ready() -> void:
	desk_debrief = load_dialogue(desk_dialogue)
	pc_debrief = load_dialogue(pc_dialogue)

	$panel/container/name.text = "Quacky McQuackFace"

	match get_parent().name:
		"desk":
			dialogue_text(desk_debrief,"Day %s.0" %(Global.unlocked+1))
		"pc":
			dialogue_text(pc_debrief,"Day %s.0"%(Global.unlocked+1))
	
	self.connect("end_dialogue", _end_dialogue)
	
# insert json text to the dialogue box
func dialogue_text(dict,option):
	dialogue_label.start(dict[option]["text"])
	current_dialogue = option

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


func _on_next_pressed() -> void:
	match get_parent().name:
		"desk":
			next_dialogue(desk_debrief)
		"pc":
			next_dialogue(pc_debrief)
		
func _on_prev_pressed() -> void:
	match get_parent().name:
		"desk":
			prev_dialogue(desk_debrief)
		"pc":
			prev_dialogue(pc_debrief)

func next_dialogue(dict):
	if dict[current_dialogue].has("go to") && dict[current_dialogue]["go to"].size() > 1:
		dialogue_text(dict, dict[current_dialogue]["go to"][1])
	else:
		emit_signal(dict[current_dialogue]["function"])

func prev_dialogue(dict):
	if dict[current_dialogue].has("go to"):
		dialogue_text(dict, dict[current_dialogue]["go to"][0])
	else:
		emit_signal(dict[current_dialogue]["function"])
