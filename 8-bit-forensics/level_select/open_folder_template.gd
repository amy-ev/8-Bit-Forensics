extends Sprite2D

func _ready() -> void:
	$back.disabled = false
	$next.disabled = false

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
