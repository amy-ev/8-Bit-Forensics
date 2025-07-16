extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	$top_screen/pc_screen.reparent($bottom_screen,false)
	await $screen_animation.animation_finished
	match day:
		1:
			add_child(load("res://dialogue/dialogue_manager.tscn").instantiate())
			$bottom_screen/pc_screen.add_child(load("res://evidence/image_file.tscn").instantiate())
		2:
			add_child(load("res://pc/desktop_icon.tscn").instantiate())


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
	if event is InputEventKey and event.is_action_pressed("escape"):
		get_tree().change_scene_to_file("res://main/desk.tscn")

func _on_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://end_quiz.tscn")
