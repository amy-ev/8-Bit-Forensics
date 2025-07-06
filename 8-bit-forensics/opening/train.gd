extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)

func _on_animation_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://main/desk.tscn")
