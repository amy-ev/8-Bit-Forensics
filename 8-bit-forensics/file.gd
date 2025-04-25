extends Control
class_name File

@export var file_name: String 

func _ready() -> void:
	file_name = $icon.texture.resource_path.get_file()
	$file_name.text = file_name

func _on_select_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		print(file_name)
