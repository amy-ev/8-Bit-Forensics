extends Control
class_name File

@export var _file_name: String 
@export var _file_icon: ImageTexture

@export var _selected_file: String

func _process(_delta: float) -> void:
	$file_name.text = _file_name
	$icon.texture = _file_icon
	
func _on_select_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		_selected_file = _file_icon.get_meta("file_name")

		Global.selected.emit(get_parent().get_node(str(self.name)), _selected_file)
