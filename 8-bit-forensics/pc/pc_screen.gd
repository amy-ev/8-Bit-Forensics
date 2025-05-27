extends Control

@onready var text_rect = $pc_screen
@onready var icon = $DesktopIcon

func _ready() -> void:
	icon.set_position(Vector2(15,15))
	print(icon.position)
	update_size()
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()

func update_size():
	var original_size = size
	size = DisplayServer.window_get_size()
	text_rect.size = size
	
	# keeping it scaled to the x axis - prevents distortion of the icon image
	icon.get_node("icon").size = icon.get_node("icon").size / (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	icon.get_node("select/select_shape").shape.size = icon.get_node("icon").size
	icon.get_node("select").position = icon.get_node("select/select_shape").shape.size / 2
	
	print(icon.size)
	print(original_size/size)
