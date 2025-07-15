extends Panel
@export var files = []

func _ready() -> void:
	$finished.disabled = true
	await $animation.animation_finished
	$finished.disabled = false

func _on_finished_pressed() -> void:
	get_parent().file_created = true
	queue_free()
