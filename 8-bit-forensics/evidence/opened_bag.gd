extends RigidBody2D

@onready var _form = preload("res://evidence/form.tscn")

func _on_form_section_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			if event.double_click:
				add_child(_form.instantiate())
