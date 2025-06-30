extends Control
class_name MyFile

@export var _file_name: String 
@export var _file_icon: CompressedTexture2D

@export var _selected_file: String

func _ready() -> void:
	#dynamically size and position area2D 
	var file_width = $icon.size.x + (4 * Global.magnification)
	var file_height = $icon.size.y + (3 * Global.magnification)
	$select/select_shape.shape.size.x = file_width
	$select/select_shape.shape.size.y = file_height
	$selected.size = Vector2(file_width, file_height)
	$select.position = $select/select_shape.shape.size / 2

func _process(delta: float) -> void:
	$file_name.text = _file_name
	$icon.texture = _file_icon
	
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		_selected_file = _file_icon.get_meta("file_name")
		
		Global.selected.emit(get_parent().get_node(str(self.name)), _selected_file)
