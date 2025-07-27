extends ColorRect
@export var files = []

#TODO: PRODUCE A MD5 HASH

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$window/next.disabled = true
	await $window/animation.animation_finished
	$window/next.disabled = false
	
func _on_next_pressed() -> void:
	Global.emit_signal("create_image_file")
	queue_free()
