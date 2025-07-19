extends CanvasLayer

var help_pressed:bool

@onready var _dialogue = preload("res://dialogue/dialogue_display.tscn")

func _ready() -> void:
	Global.connect("item_pressed", _on_item_select)
	
func _on_item_select(selected:Node):
	if help_pressed:
		var dialogue = _dialogue.instantiate()
		add_child(dialogue)
		dialogue.get_node("panel/dialogue_label").start(selected.name)
		#TODO: match case for the selected items and what should be said
		#match selected.name:
			#"evidence_tree_label":
				#dialogue.get_node("panel/dialogue_label").start("blah blah evidence tree")
		help_pressed = false


func _on_button_pressed() -> void:
	help_pressed = true
