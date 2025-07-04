extends TextureRect

func _on_tabs_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouse && event.is_pressed():

		var level_num = self.name.substr(13,1)
		
		if int(level_num) > shape_idx +1:
			$Sprite2D/AnimationPlayer.play("open_"+str(shape_idx +1)+"_backwards")
		else:
			$Sprite2D/AnimationPlayer.play("open_"+str(shape_idx +1))
			
		await $Sprite2D/AnimationPlayer.animation_finished

		queue_free()
		get_parent().add_child(load("res://level_select/level_select_"+ str(shape_idx +1) + ".tscn").instantiate())
		get_parent().move_child(get_node("../level_select_"+ str(shape_idx +1)),1)
		
		#Global.emit_signal("child_joined")
