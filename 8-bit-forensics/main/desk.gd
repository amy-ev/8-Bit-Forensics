extends TextureRect

var fullscreen:bool = false
var day = Global.unlocked + 1

var evidence_collected = false

func _ready() -> void:
	# change evidence item to match the texture of evidence_1, evidence_2 etc
	$evidence_rect.texture = load("res://assets/office/btn-x3.png")
	Global.connect("evidence_collected", _on_evidence_collect)


func _on_pc_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://pc/pc_screen.tscn")


func _on_evidence_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_double_click():
		var evidence_item = load("res://main/evidence.tscn")
		add_child(evidence_item.instantiate())


func _on_usb_port_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if evidence_collected:
			$usb_port/usb_rect.visible = true


func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_action_pressed("fullscreen"):
		if !fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			fullscreen = false
			
func _on_evidence_collect():
	$evidence_rect.queue_free()
	evidence_collected = true
