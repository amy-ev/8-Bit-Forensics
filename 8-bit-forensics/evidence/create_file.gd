extends Panel

func _ready() -> void:
	$finished.disabled = true
	await $animation.animation_finished
	$finished.disabled = false

func _on_finished_pressed() -> void:
	queue_free()
