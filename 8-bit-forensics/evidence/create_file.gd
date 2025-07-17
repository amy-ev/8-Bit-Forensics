extends Panel
@export var files = []

func _ready() -> void:
	Global.emit_signal("next_step",self)
	$next.disabled = true
	await $animation.animation_finished
	$next.disabled = false
	
func _on_next_pressed() -> void:
	get_parent().file_created = true
	queue_free()
