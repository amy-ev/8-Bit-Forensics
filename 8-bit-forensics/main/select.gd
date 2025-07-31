extends Area2D

@onready var parent = get_parent().get_class()

signal option_selected(_option:String)

func _ready() -> void:
	match parent:
		"Label":
			$select_shape.shape.size = get_parent().size/2
		"MenuButton":
			$select_shape.position = Vector2(get_parent().size.x,get_parent().size.y/2)
		"PanelContainer":
			$select_shape.shape.size.y = get_parent().size.y/2
			$select_shape.shape.size.x = get_parent().size.x
			$select_shape.position = $select_shape.shape.size/2
		_:
			$select_shape.shape.size = get_parent().size * 4
			$select_shape.position = $select_shape.shape.size/2

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if get_parent().get_class() == "PanelContainer":
			print("pressed")
			emit_signal("option_selected",get_parent().name)
		else:
			Global.emit_signal("item_pressed",get_parent())
