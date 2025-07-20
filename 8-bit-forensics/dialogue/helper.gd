extends CanvasLayer

var help_pressed:bool

@onready var _dialogue = preload("res://dialogue/dialogue_display.tscn")

func _ready() -> void:
	Global.connect("item_pressed", _on_item_select)
	Global.connect("answer_response", _on_option_confirmed)
	

func _on_item_select(selected:Node):
	if help_pressed:
		var dialogue = _dialogue.instantiate()
		add_child(dialogue)
		dialogue.get_node("npc_normal").set_visible(true)
		dialogue.get_node("npc_bad").set_visible(false)
		dialogue.get_node("npc_good").set_visible(false)
		dialogue.start(selected.name)
		#TODO: match case for the selected items and what should be said
		#match selected.name:
			#"evidence_tree_label":
				#dialogue.start("blah blah evidence tree")
		help_pressed = false

func _on_option_confirmed(is_correct:bool):
	var dialogue = _dialogue.instantiate()
	add_child(dialogue)
	if is_correct:
		dialogue.get_node("npc_normal").set_visible(false)
		dialogue.get_node("npc_bad").set_visible(false)
		dialogue.get_node("npc_good").set_visible(true)
		dialogue.start("correct!")
	else:
		dialogue.get_node("npc_normal").set_visible(false)
		dialogue.get_node("npc_good").set_visible(false)
		dialogue.get_node("npc_bad").set_visible(true)
		dialogue.start("wrong")
func _on_button_pressed() -> void:
	help_pressed = true
