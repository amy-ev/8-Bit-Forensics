extends TextureRect

var day = Global.unlocked +1

func _ready() -> void:
	$evidence.texture = load("res://assets/crime_board/notes/"+str(day)+"-note-x3.png")
	

func _on_back_pressed() -> void:
	queue_free()
