extends Control
class_name File

@export var file_name: String 
@export var file_icon: ImageTexture

func _ready() -> void:
	pass
	#file_name = $icon.texture.resource_path.get_file()

func _process(delta: float) -> void:
	$file_name.text = file_name
	$icon.texture = file_icon
	
func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		get_parent().get_parent().get_node("load_button").text = file_name
		#$file_name.text = file_name
