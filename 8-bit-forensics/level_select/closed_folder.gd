extends Sprite2D

func _on_next_pressed() -> void:
	$AnimationPlayer.play("open_1")
	
	await $AnimationPlayer.animation_finished
	
	queue_free()
	get_parent().add_child(load("res://level_select/level_select_1.tscn").instantiate())
	get_parent().move_child(get_node("../level_select_1"),1)
