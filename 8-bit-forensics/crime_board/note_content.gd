extends NinePatchRect

@export var scaled_by: Vector2

func _ready() -> void:
	update_size()
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()

func update_size():
	var original_size = size
	
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	
	#var window_size = DisplayServer.window_get_size()
	size = size / scaled_by
	
	# keeping it scaled to the x axis - prevents distortion of the icon image
