extends ColorRect

@export var files = []

@onready var screen = get_parent()
@onready var pc = screen.get_parent()
#TODO: PRODUCE A MD5 HASH

func _ready() -> void:
	Global.emit_signal("dialogue_triggered","e5.4")
	Global.emit_signal("next_step",self)
	
	$window/next.disabled = true
	await $window/animation.animation_finished
	$window/next.disabled = false
	
func _on_next_pressed() -> void:
	screen.add_child(preload("res://pc/hash.tscn").instantiate())
	
	Global.emit_signal("create_image_file")
	Global.file_created = true
	queue_free()
