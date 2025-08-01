extends CanvasLayer

@onready var dialogue_label = $panel/dialogue_label
var dialogue_dict:= {}
var topic:String

func _ready() -> void:
	Global.connect("text_finished", _on_text_finished)

func start(dialogue:String):
	dialogue_label.start(dialogue)
	$animation.play("talk")
	
func load_dialogue(file_path, _topic):
	if FileAccess.file_exists(file_path):
		var dialogue = FileAccess.open(file_path, FileAccess.READ)
		dialogue_dict = JSON.parse_string(dialogue.get_as_text())
		dialogue_text(dialogue_dict, _topic)

func dialogue_text(dict,_option):
	start(dict[_option]["text"])
	$dialogue_option/label.text = dict[_option]["option display"]
	topic = _option

func _on_text_finished():
	$animation.stop()

func _on_select_option_selected(_option: String) -> void:
	$npc.set_visible(true)
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		if dialogue_dict[topic].has("go to"):
			if dialogue_dict[topic]["go to"].size() > 1:
				if dialogue_dict[topic]["go to"][1] == "dispatch":
					$npc.set_visible(false)
					
			dialogue_text(dialogue_dict,dialogue_dict[topic]["go to"][0])
		else:
			queue_free()
			
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("enter"):
		dialogue_label.skip()
