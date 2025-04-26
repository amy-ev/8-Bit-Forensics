extends Control
class_name File

@export var _file_name: String 
@export var _file_icon: ImageTexture

@export var _selected_file: String

func _ready() -> void:
	
	#dynamically size and position area2D 
	$select/select_shape.shape.size.x = $icon.size.x + 4
	$select/select_shape.shape.size.y = $icon.size.y + 4
	$select.position = $select/select_shape.shape.size / 2
	
func _process(delta: float) -> void:
	$file_name.text = _file_name
	$icon.texture = _file_icon
	
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		_selected_file = _file_icon.get_meta("file_name")
		#print(get_parent())
		#print(get_parent().get_parent().get_parent().get_parent())
		get_parent().get_parent().get_parent().get_parent().get_node("load_button").text = _selected_file
		print(_selected_file)
		#$file_name.text = file_name
