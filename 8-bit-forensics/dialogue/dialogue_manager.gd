extends CanvasLayer

var desk_dialogue = "res://dialogue/debrief_dialogue.json"

@export var desk_debrief = {}
var pc_debrief = {}
var current_dialogue = ""

var option:String
var display_options:= [0,0]
@onready var dialogue_label = $panel/container/dialogue_label

signal end_dialogue

func _ready() -> void:
	Global.connect("text_finished", _on_text_finished)
	self.connect("end_dialogue", _end_dialogue)

	$panel/container/name.text = "Chief Quacky McQuackFace"
	load_dialogue(desk_dialogue,"Day %s.0"%(Global.unlocked+1))
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("enter"):
		dialogue_label.skip()

func start(dialogue:String):
	if dialogue.contains("This is the star of the show"):
		var sd_card = preload("res://evidence/sd_card.tscn").instantiate()
		add_child(sd_card)
		sd_card.name = "sd_card"
	else:
		if has_node("sd_card"):
			get_node("sd_card").queue_free()
		
	dialogue_label.start(dialogue)
	$option_a.set_visible(false)
	$option_b.set_visible(false)
	$animation.play("talk")
	
# insert json text to the dialogue box
func dialogue_text(dict,_option):
	
	start(dict[_option]["text"])
	if dict[_option]["option display"].size() > 1:
		$option_b/label.text = dict[_option]["option display"][1]

	$option_a/label.text = dict[_option]["option display"][0]
	current_dialogue = _option
	
func _end_dialogue():
	Global.debrief_given = true
	queue_free()
	
func load_dialogue(file_path, _current_dialogue):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		desk_debrief = JSON.parse_string(dialogue.get_as_text())
		dialogue_text(desk_debrief, _current_dialogue)

func _on_text_finished():
	$animation.stop()
	
	if desk_debrief[current_dialogue]["option display"].size() > 1:
		$option_a.set_visible(true)
		$option_b.set_visible(true)
	else:
		$option_a.set_visible(true)
		

func _on_option_a_selected(_option: String) -> void:
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		if desk_debrief[current_dialogue].has("go to"):
			dialogue_text(desk_debrief,desk_debrief[current_dialogue]["go to"][0])
		else:
			emit_signal(desk_debrief[current_dialogue]["function"])

func _on_option_b_selected(_option: String) -> void:
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		if desk_debrief[current_dialogue].has("go to"):
			dialogue_text(desk_debrief,desk_debrief[current_dialogue]["go to"][1])
		else:
			emit_signal(desk_debrief[current_dialogue]["function"])
