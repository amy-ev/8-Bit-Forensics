extends CanvasLayer

var dialogue_file = "res://dialogue/dialogue.json"
var dialogue_data = {}
var current_dialogue = ""

signal end_dialogue

func _ready() -> void:
	dialogue_data = load_dialogue(dialogue_file)
	print(dialogue_data)
	$Control/container/day_title.text = "Day %s" %(Global.unlocked+1)
	dialogue_text($Control/container/text, "Day %s.0" %(Global.unlocked+1))
	
	self.connect("end_dialogue", _end_dialogue)
	
# insert json text to the dialogue box
func dialogue_text(node,option):
	node.text = dialogue_data[option]["text"]
	current_dialogue = option
	
func _on_next_pressed() -> void:
	if dialogue_data[current_dialogue].has("go to") && dialogue_data[current_dialogue]["go to"].size() > 1:
		dialogue_text($Control/container/text, dialogue_data[current_dialogue]["go to"][1])
	else:
		emit_signal(dialogue_data[current_dialogue]["function"])

func _on_prev_pressed() -> void:
	if dialogue_data[current_dialogue].has("go to"):
		dialogue_text($Control/container/text, dialogue_data[current_dialogue]["go to"][0])
	else:
		emit_signal(dialogue_data[current_dialogue]["function"])
		
func _end_dialogue():
	queue_free()
	
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		return JSON.parse_string(dialogue.get_as_text())
