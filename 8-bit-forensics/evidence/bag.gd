extends Sprite2D


func _on_bag_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			#animation to zoom into bag
			$bag/collision.disabled = true
			#add_child(evidence_form)
			#await evidence_form.queue_free
			
func _on_cut_section_area_entered(area: Area2D) -> void:
	if area.name == "blades":
		if area.get_parent().is_picked_up:
			area.get_parent().is_picked_up = false
			#play cutting animation 
			#ends with bag removed to the side and the evidence on the table
	
