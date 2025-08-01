extends Node2D

var day = Global.unlocked + 1

var evidence_collected = false
var file_created = false
@onready var _debrief = preload("res://dialogue/dialogue_manager.tscn")
@onready var _dialogue = preload("res://dialogue/redirect_dialogue.tscn")

func _ready() -> void:
	if !Global.debrief_given:
		var debrief = _debrief.instantiate()
		add_child(debrief)
	if day != 1:
		$bottom_screen/evidence_bag.visible = false
		evidence_collected = true
	scale = scale * Utility.window_mode()
	Global.connect("evidence_collected", _on_evidence_collect)
	Global.connect("evidence_finished", _on_evidence_finished)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_evidence_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_double_click():
		if Global.is_first_bag || Global.file_created:
			var evidence_item = load("res://evidence/desk.tscn")
			$bottom_screen.add_child(evidence_item.instantiate())
		else:
			var dialogue = _dialogue.instantiate()
			add_child(dialogue)
			dialogue.start("lets make the image file!")

func _on_evidence_collect():
	evidence_collected = true
func _on_evidence_finished():
	if has_node("full_dialogue_display"):
		remove_child(get_node("full_dialogue_display"))
	var dialogue = preload("res://dialogue/full_dialogue_display.tscn").instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e9.0")
	await dialogue.tree_exited
	get_tree().change_scene_to_file("res://quiz/end_quiz.tscn")
	
func _on_pc_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
		if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if evidence_collected:
						get_tree().change_scene_to_file("res://pc/pc_screen.tscn")
					
				else:
					if !Global.is_first_bag && Global.file_created:
						var dialogue = _dialogue.instantiate()
						add_child(dialogue)
						dialogue.start("lets put the evidence away")
					else:
						var dialogue = _dialogue.instantiate()
						add_child(dialogue)
						dialogue.start("lets collect the item first")

func _on_coffee_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			print("ouch!")
