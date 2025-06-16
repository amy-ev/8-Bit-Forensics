extends Control

@onready var text_rect = $pc_screen
@onready var icon = $DesktopIcon
@onready var icon2 = $DesktopIcon2
@export var scaled_by: Vector2

@onready var image_file = preload("res://image_file.tscn")

func _ready() -> void:
	icon.set_position(Vector2(15,15))
	icon2.set_position(Vector2(15,85))

	update_size()
	var img_f = image_file.instantiate()
	add_child(img_f)
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()

func update_size():
	var original_size = size

	size = DisplayServer.window_get_size()
	text_rect.size = size
	
	# keeping it scaled to the x axis - prevents distortion of the icon image
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	
	icon.get_node("icon").size = icon.get_node("icon").size / scaled_by
	icon.get_node("select/select_shape").shape.size = icon.get_node("icon").size
	icon.get_node("select").position = icon.get_node("select/select_shape").shape.size / 2
	
	icon2.get_node("icon").size = icon2.get_node("icon").size / scaled_by
	icon2.get_node("select/select_shape").shape.size = icon2.get_node("icon").size
	icon2.get_node("select").position = icon2.get_node("select/select_shape").shape.size / 2
