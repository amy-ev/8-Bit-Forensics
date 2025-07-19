extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	
	await $screen_animation.animation_finished
	#$top_screen/pc_screen.reparent($bottom_screen,false)
	match day:
		1:
			#$top_screen.add_child(load("res://dialogue/dialogue_create_file.tscn").instantiate())

			var image_file = load("res://evidence/image_file.tscn").instantiate()
			$top_screen/pc_screen.add_child(image_file)
		2:
			add_child(load("res://pc/desktop_icon.tscn").instantiate())


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
		
	if event is InputEventKey and event.is_action_pressed("escape"):
		if has_node("bottom_screen/dialogue_create_file"):
			get_node("bottom_screen/dialogue_create_file").queue_free()
			
		elif has_node("top_screen/dialogue_create_file"):
			get_node("top_screen/dialogue_create_file").queue_free()
			
		if has_node("bottom_screen/pc_screen"):
			get_node("bottom_screen/pc_screen").get_child(0).queue_free()
			get_node("bottom_screen/pc_screen").reparent($top_screen, false)
			
		elif has_node("top_screen/pc_screen"):
			get_node("top_screen/pc_screen").get_child(0).queue_free()
			
		$screen_animation.play("off")
		await $screen_animation.animation_finished
		
		get_tree().change_scene_to_file("res://main/desk.tscn")

func _on_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://end_quiz.tscn")
