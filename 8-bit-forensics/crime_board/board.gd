extends TextureRect

@onready var note = preload("res://crime_board/note_content.tscn")

@onready var note_rect = $note
@export var scaled_by: Vector2

func _ready() -> void:
	update_size()
	Global.connect("note_selected", _open_note)

func _open_note():
	#TODO: have the signal pass a parameter to match the specific note needed 
	add_child(note.instantiate())
	
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()
		
func update_size():
	var original_size = size

	size = DisplayServer.window_get_size()
	
	# keeping it scaled to the x axis - prevents distortion of the icon image
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	
	note_rect.size = note_rect.size / scaled_by
	note_rect.get_node("area/area_shape").shape.size = note_rect.size
	note_rect.get_node("area").position = note_rect.get_node("area/area_shape").shape.size / 2
