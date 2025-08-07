extends Sprite2D

func _ready() -> void:
	$back.disabled = false
	$next.disabled = false
	
	if has_node("play"):
		var unlocked = int(Global.get_save(Global.user_path + "savefile.json"))

		if unlocked >= 3:
			if name.contains("3"):
				$play.set_visible(true)
		if unlocked >= 2:
			if name.contains("2"):
				$play.set_visible(true)
		if unlocked >= 1:
			if name.contains("1"):
				$play.set_visible(true)
		else:
			$play.set_visible(false)
			
func _on_next_pressed() -> void:
	var level_num = self.name.substr(13,1)
	$AnimationPlayer.play("open_"+str(int(level_num) +1))
	$next.disabled = true
	await $AnimationPlayer.animation_finished

	queue_free()
	get_parent().add_child(load("res://level_select/level_select_"+ str(int(level_num) +1) + ".tscn").instantiate())
	get_parent().move_child(get_node("../level_select_"+ str(int(level_num) +1)),1)


func _on_back_pressed() -> void:
	var level_num = self.name.substr(13,1)
	$AnimationPlayer.play("open_"+str(int(level_num) - 1)+"_backwards")
	$back.disabled = true
	await $AnimationPlayer.animation_finished

	queue_free()
	if int(level_num) > 1:
		get_parent().add_child(load("res://level_select/level_select_"+ str(int(level_num) - 1) + ".tscn").instantiate())
		get_parent().move_child(get_node("../level_select_"+ str(int(level_num) - 1)),1)
	else:
		get_parent().add_child(load("res://level_select/closed_folder.tscn").instantiate())
		get_parent().move_child(get_node("../closed_folder"),1)


func _on_play_pressed() -> void:
	Global.level_selected = true
	if name.contains("1"):
		Global.unlocked = 0
	elif name.contains("2"):
		Global.unlocked = 1
	elif name.contains("3"):
		Global.unlocked = 2
	else:
		Global.unlocked = 0
	get_tree().change_scene_to_file("res://opening/waking_up.tscn")
