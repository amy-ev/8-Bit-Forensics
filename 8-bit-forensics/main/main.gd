extends Node2D

func _ready() -> void:
	scale = scale * Utility.window_mode()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
