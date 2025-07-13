extends Sprite2D

func _on_tabs_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse && event.is_pressed():

		$AnimationPlayer.play("open_"+str(shape_idx +1))
		
		await $AnimationPlayer.animation_finished
		
		queue_free()
		get_parent().add_child(load("res://level_select/level_select_"+ str(shape_idx +1) + ".tscn").instantiate())
		get_parent().move_child(get_node("../level_select_"+ str(shape_idx +1)),1)

		#Global.emit_signal("child_joined")


func _on_next_pressed() -> void:
	$AnimationPlayer.play("open_1")
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
	get_parent().add_child(load("res://level_select/level_select_1.tscn").instantiate())
	get_parent().move_child(get_node("../level_select_1"),1)
