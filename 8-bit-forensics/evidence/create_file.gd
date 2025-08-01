extends ColorRect

@export var files = []

@onready var pc = get_parent()
#TODO: PRODUCE A MD5 HASH

func _ready() -> void:
	
	if pc.has_node("dialogue_display"):
		pc.remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	pc.add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e5.4")
	
	Global.emit_signal("next_step",self)
	$window/next.disabled = true
	await $window/animation.animation_finished
	$window/next.disabled = false
	
func _on_next_pressed() -> void:
	pc.add_child(preload("res://pc/hash.tscn").instantiate())
	Global.emit_signal("create_image_file")
	queue_free()
