extends TextureRect

@onready var note = preload("res://crime_board/note_content.tscn")

@onready var note_rects = []
@export var scaled_by: Vector2

func _ready() -> void:
	update_size()
	Global.connect("note_selected", _open_note)

func _open_note(note_topic:String):
	#TODO: have the signal pass a parameter to match the specific note needed 
	var note_content = note.instantiate()
	note_content.get_child(0).text = note_topic
	add_child(note_content)
	
func _notification(what: int) -> void:
	if what == 1012:
		update_size()
		
func update_size():
	var original_size = size

	size = DisplayServer.window_get_size()
	
	# keeping it scaled to the x axis - prevents distortion of the icon image
	scaled_by = (Vector2(original_size.x -1, original_size.x -1)/Vector2(size.x-1,size.x-1))
	for note_rect in range(get_children().size()):
		print(get_child(note_rect).name)
		
		get_child(note_rect).size = get_child(note_rect).size / scaled_by
		get_child(note_rect).get_node("area/area_shape").shape.size = get_child(note_rect).size
		get_child(note_rect).get_node("area").position = get_child(note_rect).get_node("area/area_shape").shape.size / 2
