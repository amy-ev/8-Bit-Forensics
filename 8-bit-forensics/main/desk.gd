extends Node2D

var day = Global.unlocked + 1

var evidence_collected = false

func _ready() -> void:
	if day != 1:
		$bottom_screen/evidence_bag.visible = false
	scale = scale * Utility.window_mode()
	Global.connect("evidence_collected", _on_evidence_collect)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_evidence_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_double_click():
		var evidence_item = load("res://evidence/desk.tscn")
		$bottom_screen.add_child(evidence_item.instantiate())

func _on_evidence_collect():
	$bottom_screen/evidence_bag.queue_free()
	evidence_collected = true


func _on_pc_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_double_click():
			get_tree().change_scene_to_file("res://pc/pc_screen.tscn")

func _on_coffee_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			print("ouch!")
