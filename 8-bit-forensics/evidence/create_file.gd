extends NinePatchRect
@export var files = []

#TODO: PRODUCE A MD5 HASH

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$next.disabled = true
	await $animation.animation_finished
	$next.disabled = false
	
func _on_next_pressed() -> void:
	Global.emit_signal("create_image_file")
	queue_free()
