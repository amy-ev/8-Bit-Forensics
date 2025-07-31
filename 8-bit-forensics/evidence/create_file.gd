extends ColorRect
@export var files = []

#TODO: PRODUCE A MD5 HASH

func _ready() -> void:
	
	if get_parent().has_node("dialogue_display"):
		get_parent().remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	get_parent().add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e5.4")
	
	Global.emit_signal("next_step",self)
	$window/next.disabled = true
	await $window/animation.animation_finished
	$window/next.disabled = false
	
func _on_next_pressed() -> void:
	Global.emit_signal("create_image_file")
	queue_free()
