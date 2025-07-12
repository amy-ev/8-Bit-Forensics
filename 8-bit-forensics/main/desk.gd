extends Node2D

var day = Global.unlocked + 1

var evidence_collected = false

func _ready() -> void:
	if day != 1:
		$evidence_rect.visible = false
	scale = scale * Utility.window_mode()
	# change evidence item to match the texture of evidence_1, evidence_2 etc
	$evidence_rect.texture = load("res://assets/office/btn-x3.png")
	Global.connect("evidence_collected", _on_evidence_collect)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_pc_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://pc/pc_screen.tscn")


func _on_evidence_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_double_click():
		var evidence_item = load("res://evidence/desk.tscn")
		add_child(evidence_item.instantiate())

func _on_usb_port_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if evidence_collected:
			$usb_port/usb_rect.visible = true

func _on_evidence_collect():
	$evidence_rect.queue_free()
	evidence_collected = true
