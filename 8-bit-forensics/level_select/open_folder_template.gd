extends Sprite2D

func _ready() -> void:
	$back.disabled = false
	$next.disabled = false
	
	if has_node("level1") && has_node("level2") && has_node("level3"):
		var unlocked = int(Global.get_save(Global.user_path + "savefile.json"))

		if unlocked >= 3:
			if has_node("play"):
				_show_play()
			$level1.set_visible(true)
			$level2.set_visible(true)
			$level3.set_visible(true)
			$confidential1.set_visible(false)
			$confidential2.set_visible(false)
			$confidential3.set_visible(false)
			$confidential4.set_visible(true)
		elif unlocked >= 2:
			if has_node("play"):
				_show_play()
			$level1.set_visible(true)
			$level2.set_visible(true)
			$level3.set_visible(false)
			$confidential1.set_visible(false)
			$confidential2.set_visible(false)
			$confidential3.set_visible(true)
			$confidential4.set_visible(true)
		elif unlocked >= 1:
			if has_node("play"):
				_show_play()
			$level1.set_visible(true)
			$level2.set_visible(false)
			$level3.set_visible(false)
			$confidential1.set_visible(false)
			$confidential2.set_visible(true)
			$confidential3.set_visible(true)
			$confidential4.set_visible(true)
		else:
			$level1.set_visible(false)
			$level2.set_visible(false)
			$level3.set_visible(false)
			$confidential1.set_visible(true)
			$confidential2.set_visible(true)
			$confidential3.set_visible(true)
			$confidential4.set_visible(true)
			
func _on_next_pressed() -> void:
	var level_num = self.name.substr(13,1)
	$next.disabled = true
	$AnimationPlayer.play("open_"+str(int(level_num) +1))
	await $AnimationPlayer.animation_finished

	queue_free()
	get_parent().add_child(load("res://level_select/level_select_"+ str(int(level_num) +1) + ".tscn").instantiate())
	get_parent().move_child(get_node("../level_select_"+ str(int(level_num) +1)),1)


func _on_back_pressed() -> void:
	var level_num = self.name.substr(13,1)
	$back.disabled = true
	$AnimationPlayer.play("open_"+str(int(level_num) - 1)+"_backwards")
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
	Global.day_start()
	get_tree().change_scene_to_file("res://opening/waking_up.tscn")

func _show_play():
	var unlocked = int(Global.get_save(Global.user_path + "savefile.json"))
	if unlocked >= 3:
		if name.contains("1") || name.contains("2") || name.contains("3"):
			get_node("play").set_visible(true)
		else:
			get_node("play").set_visible(false)
	elif unlocked >= 2:
		if name.contains("1") || name.contains("2"):
			get_node("play").set_visible(true)
		else:
			get_node("play").set_visible(false)
	elif unlocked >= 1:
		if name.contains("1"):
			get_node("play").set_visible(true)
		else:
			get_node("play").set_visible(false)
	else:
		get_node("play").set_visible(false)
