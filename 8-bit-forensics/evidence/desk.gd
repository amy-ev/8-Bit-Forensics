extends TextureRect

@onready var _opened_bag = preload("res://evidence/opened_bag.tscn")
@onready var _new_bag = preload("res://evidence/new_bag.tscn")
@onready var _moveable_evidence = preload("res://evidence/moveable_evidence.tscn")

@onready var pc = get_parent().get_node("pc/pc_area/pc_shape")
@onready var coffee = get_parent().get_node("coffee_cup/coffee/coffee_shape")
@onready var evidence = get_parent().get_node("evidence_bag/evidence/evidence_shape")

@onready var _dialogue = preload("res://dialogue/dialogue_display.tscn")
@onready var _full_dialogue = preload("res://dialogue/full_dialogue_display.tscn")

var evidence_collected:bool

func _ready() -> void:
	Global.connect("form_filled", _on_form_filled)
	Global.connect("evidence_collected", _on_evidence_collected)
	
	if Global.is_first_bag:
		if has_node("dialogue_display"):
			remove_child(get_node("dialogue_display"))
		var dialogue = _dialogue.instantiate()
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
		var dialogue = _dialogue.instantiate()
		add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e8.0")
		
	pc.disabled = true
	coffee.disabled = true
	evidence.disabled = true
	
func _on_back_pressed() -> void:
	if evidence_collected:
		if get_parent().has_node("dialogue_display"):
			get_parent().remove_child(get_node("dialogue_display"))
		var dialogue = _full_dialogue.instantiate()
		get_parent().add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e4.0")
		
	pc.disabled = false
	coffee.disabled = false
	evidence.disabled = false
	queue_free()
	
func _on_form_filled():
	if self.has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = _dialogue.instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e2.0")

func _on_evidence_collected():
	evidence_collected = true
	if self.has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = _dialogue.instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e3.0")
