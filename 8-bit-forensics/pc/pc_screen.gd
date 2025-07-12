extends Node2D

func _ready() -> void:
	var day = Global.unlocked + 1
	match day:
		1:
			add_child(load("res://evidence/image_file.tscn").instantiate())
		2:
			add_child(load("res://evidence/image_file.tscn").instantiate())
			add_child(load("res://pc/desktop_icon.tscn").instantiate())
	scale = scale * Utility.window_mode()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_debug_pressed() -> void:
	get_tree().change_scene_to_file("res://end_quiz.tscn")
