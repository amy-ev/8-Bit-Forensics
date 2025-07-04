extends TextureRect

func _on_tabs_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse && event.is_pressed():

		$Sprite2D/AnimationPlayer.play("open_1")
		
		await $Sprite2D/AnimationPlayer.animation_finished
		
		queue_free()
		get_parent().add_child(load("res://level_select/level_select_"+ str(shape_idx +1) + ".tscn").instantiate())
		get_parent().move_child(get_node("../level_select_"+ str(shape_idx +1)),1)

		#Global.emit_signal("child_joined")
