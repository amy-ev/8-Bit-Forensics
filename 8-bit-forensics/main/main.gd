extends Node2D

func _ready() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		Global.fullscreen = true
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		scale = scale/1.5
		Global.fullscreen = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		if !Global.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			scale = scale*1.5
			Global.fullscreen = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Global.fullscreen = false
			scale = scale/1.5
