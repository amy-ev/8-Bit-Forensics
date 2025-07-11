extends TextureRect

@export var note_topic:String

func _ready() -> void:
	note_topic = get_node(".").name
	
func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		if event.is_double_click():
			Global.note_selected.emit(note_topic)
