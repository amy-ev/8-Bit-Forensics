extends Node2D

var dialogue_file = "res://dialogue/dialogue.json"
@export var dialogue_data = {}
@export var current_dialogue = ""

signal end_dialogue

func _ready() -> void:
	dialogue_data = load_dialogue(dialogue_file)
	get_parent().get_parent().get_node("bottom_screen/evidence_bag/evidence/evidence_shape").disabled = true
	get_parent().get_parent().get_node("bottom_screen/pc/pc_area/pc_shape").disabled = true
	get_parent().get_parent().get_node("bottom_screen/coffee_cup/coffee/coffee_shape").disabled = true
	$dialogue_box/container/day_title.text = "Day %s" %(Global.unlocked+1)
	dialogue_text($dialogue_box/container/text, "Day %s.0" %(Global.unlocked+1))
	
	self.connect("end_dialogue", _end_dialogue)
	
# insert json text to the dialogue box
func dialogue_text(node,option):
	node.text = dialogue_data[option]["text"]
	current_dialogue = option

func _end_dialogue():
	get_parent().get_parent().get_node("bottom_screen/evidence_bag/evidence/evidence_shape").disabled = false
	get_parent().get_parent().get_node("bottom_screen/pc/pc_area/pc_shape").disabled = false
	get_parent().get_parent().get_node("bottom_screen/coffee_cup/coffee/coffee_shape").disabled = false
	get_parent().get_parent().get_node("bottom_screen/next").queue_free()
	get_parent().get_parent().get_node("bottom_screen/prev").queue_free()
	queue_free()
	
func load_dialogue(file_path):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		return JSON.parse_string(dialogue.get_as_text())
