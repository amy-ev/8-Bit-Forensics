extends TextureRect

@onready var note = preload("res://crime_board/note_content.tscn")

func _ready() -> void:
	Global.connect("note_selected", _open_note)

func _open_note():
	#TODO: have the signal pass a parameter to match the specific note needed 
	add_child(note.instantiate())
