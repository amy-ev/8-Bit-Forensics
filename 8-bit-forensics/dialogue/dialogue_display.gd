extends CanvasLayer

@onready var dialogue_label = $panel/dialogue_label
var dialogue_dict:= {}
var topic:String

func _ready() -> void:
	Global.connect("text_finished", _on_text_finished)

func _on_button_pressed() -> void:
	pass
	if dialogue_label.is_playing:
		dialogue_label.skip()
	else:
		if dialogue_dict[topic].has("go to"):
			print(topic)
			print(dialogue_dict[topic]["go to"])
			dialogue_text(dialogue_dict,dialogue_dict[topic]["go to"][0])
		else:
			queue_free()
	#if get_parent().has_node("button"):
		#get_parent().get_node("button").set_pressed(false)
		#queue_free()
	#if get_parent().name == "new_bag":
		#get_tree().change_scene_to_file("res://quiz/end_quiz.tscn")

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
	topic = _option

func _on_text_finished():
	$animation.stop()
