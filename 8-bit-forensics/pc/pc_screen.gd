extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	
	await $screen_animation.animation_finished

	var dialogue = load("res://dialogue/dialogue_manager.tscn").instantiate()
	add_child(dialogue)
	dialogue.get_node("normal").set_visible(false)
	
	match day:
		1:
			var image_file = load("res://evidence/image_file.tscn").instantiate()
			$top_screen/pc_screen.add_child(image_file)
		2:
			add_child(load("res://metadata/metadata.tscn").instantiate())

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
		
	if event is InputEventKey and event.is_action_pressed("escape"):
		if has_node("dialogue_create_file"):
			get_node("dialogue_create_file").queue_free()
			
		if has_node("pc_screen"):
			for i in get_node("pc_screen").get_child_count():
				get_node("pc_screen").get_child(i).queue_free()
		
		$screen_animation.play("off")
		await $screen_animation.animation_finished
		
		get_tree().change_scene_to_file("res://main/desk.tscn")
