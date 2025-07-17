extends Panel

@onready var popup = $MenuButton.get_popup()
var msg = "file1"
@export var file_created:bool

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$MenuButton.grab_focus()
	popup.id_pressed.connect(func(id: int):
		menu_popup(id))

func menu_popup(id):
	if id == 0:
		add_child(load("res://evidence/select_source.tscn").instantiate())

func _draw() -> void:
	if file_created:
		$end.set_visible(true)
		print("created")
		#change to match the file contents of the sd card
		var file_1 = $evidence_tree.create_item()
		file_1.set_text(0,msg)


func _on_end_pressed() -> void:
	get_tree().change_scene_to_file("res://end_quiz.tscn")
