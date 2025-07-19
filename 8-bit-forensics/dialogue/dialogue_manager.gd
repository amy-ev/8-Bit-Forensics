extends CanvasLayer

var dialogue_file = "res://dialogue/dialogue.json"
@export var dialogue_data = {}
@export var current_dialogue = ""

@onready var dialogue_label = $normal/side_dialogue/container/dialogue_label

signal end_dialogue

func _ready() -> void:
	dialogue_data = load_dialogue(dialogue_file)
	$normal/side_dialogue/container/day_title.text = "Day %s" %(Global.unlocked+1)
	dialogue_text("Day %s.0" %(Global.unlocked+1))
	
	self.connect("end_dialogue", _end_dialogue)
	
# insert json text to the dialogue box
func dialogue_text(option):
	dialogue_label.start(dialogue_data[option]["text"])
	current_dialogue = option

func _end_dialogue():
	Global.debrief_given = true
	queue_free()
	
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		return JSON.parse_string(dialogue.get_as_text())


func _on_next_pressed() -> void:
	if dialogue_data[current_dialogue].has("go to") && dialogue_data[current_dialogue]["go to"].size() > 1:
		dialogue_text(dialogue_data[current_dialogue]["go to"][1])
	else:
		emit_signal(dialogue_data[current_dialogue]["function"])


func _on_prev_pressed() -> void:
	if dialogue_data[current_dialogue].has("go to"):
		dialogue_text(dialogue_data[current_dialogue]["go to"][0])
	else:
		emit_signal(dialogue_data[current_dialogue]["function"])
