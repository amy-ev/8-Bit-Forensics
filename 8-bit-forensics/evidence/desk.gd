extends TextureRect

@onready var _opened_bag = preload("res://evidence/opened_bag.tscn")
@onready var _new_bag = preload("res://evidence/new_bag.tscn")
@onready var _moveable_evidence = preload("res://evidence/moveable_evidence.tscn")

var evidence_collected:bool

func _ready() -> void:
	Global.connect("form_filled", _on_form_filled)
	Global.connect("evidence_collected", _on_evidence_collected)
	
	if Global.is_first_bag:
		if has_node("dialogue_display"):
			remove_child(get_node("dialogue_display"))
		var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
		add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e1.0")
		
	if !Global.is_first_bag:
		$evidence_bag.queue_free()
		$evidence.queue_free()
		add_child(_opened_bag.instantiate(),true)
		add_child(_new_bag.instantiate(), true)
		add_child(_moveable_evidence.instantiate(),true)
		
		if has_node("dialogue_display"):
			remove_child(get_node("dialogue_display"))
		var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
		add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e8.0")
		
	get_parent().get_node("pc/pc_area/pc_shape").disabled = true
	get_parent().get_node("coffee_cup/coffee/coffee_shape").disabled = true
	
func _on_back_pressed() -> void:
	if evidence_collected:
		if get_parent().has_node("dialogue_display"):
			get_parent().remove_child(get_node("dialogue_display"))
		var dialogue = preload("res://dialogue/full_dialogue_display.tscn").instantiate()
		get_parent().add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e4.0")

	queue_free()
	get_parent().get_node("pc/pc_area/pc_shape").disabled = false
	get_parent().get_node("coffee_cup/coffee/coffee_shape").disabled = false
	
func _on_form_filled():
	if self.has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e2.0")

func _on_evidence_collected():
	evidence_collected = true
	if self.has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e3.0")
