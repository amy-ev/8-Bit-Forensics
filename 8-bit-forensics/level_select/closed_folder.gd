extends Sprite2D

func _on_next_pressed() -> void:
	var unlocked = int(Global.get_save(Global.user_path + "savefile.json"))
	if unlocked >= 1:
		$level1.set_visible(true)
		$confidential.set_visible(false)
	else:
		$level1.set_visible(false)
		$confidential.set_visible(true)
	$next.disabled = true
	$AnimationPlayer.play("open_1")

	await $AnimationPlayer.animation_finished
	
	queue_free()
	get_parent().add_child(load("res://level_select/level_select_1.tscn").instantiate())
	get_parent().move_child(get_node("../level_select_1"),1)
