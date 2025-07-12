extends Panel

@onready var popup = $MenuButton.get_popup()

func _ready() -> void:
	popup.id_pressed.connect(func(id: int):
		menu_popup(id))

func menu_popup(id):
	if id == 0:
		add_child(load("res://evidence/select_source.tscn").instantiate())
	
