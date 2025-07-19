extends Area2D

func _ready() -> void:
	print(get_parent().get_class())
	
	if get_parent().get_class() == "Label":
		$select_shape.shape.size = get_parent().size/2
	else:
		$select_shape.shape.size = get_parent().size
		

	if get_parent().get_class() == "MenuButton":
		$select_shape.position = Vector2(get_parent().size.x,get_parent().size.y/2)
	else:
		$select_shape.position = $select_shape.shape.size/2



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Global.emit_signal("item_pressed",get_parent())
