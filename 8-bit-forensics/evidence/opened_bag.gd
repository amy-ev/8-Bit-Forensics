extends RigidBody2D

@onready var _form = preload("res://evidence/form.tscn")
var is_picked_up:bool = false

func _on_form_section_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			if event.double_click:
				add_child(_form.instantiate())


func _on_bag_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			is_picked_up = true
			pass
		if event.is_released():
			is_picked_up = false
			
func _process(delta: float) -> void:
	if is_picked_up:
		global_position = get_global_mouse_position() - ($bag/collision.shape.size / 2)
	else:
		global_position = global_position


func _on_bag_area_entered(area: Area2D) -> void:
	$form_section/interact.set_deferred("disabled", true)


func _on_bag_area_exited(area: Area2D) -> void:
	$form_section/interact.set_deferred("disabled", false)
