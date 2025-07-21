extends Sprite2D

var is_picked_up = false

func _on_grab_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			is_picked_up = true
			if $grab_animation.is_playing():
				await $grab_animation.animation_finished
			$grab_animation.play("picked_up")
		if event.is_released():
			is_picked_up = false
			if $grab_animation.is_playing():
				await $grab_animation.animation_finished
			$grab_animation.play("put_down")

func _process(delta: float) -> void:
	if is_picked_up:
		global_position = get_global_mouse_position() - $grab/collision.shape.size / 2
	else:
		global_position = global_position
