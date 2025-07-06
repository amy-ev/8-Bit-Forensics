extends Node
class_name Utility

static var fullscreen:bool 

static func window_mode()-> float:
	var scaler:float
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen = true
		scaler = 1.0
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		fullscreen = false
		scaler = float(2.0/3.0)
	return scaler

static func fullscreen_input(_event: InputEvent) -> float:
	var scaler:float
	if !fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		scaler = 1.5
		fullscreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen = false
		scaler = float(2.0/3.0)
	return scaler
	
