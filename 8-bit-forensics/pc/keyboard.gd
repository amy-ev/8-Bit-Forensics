extends TextureRect

func _input(event: InputEvent) -> void:
	if event is InputEventKey && event.is_pressed():
		print(event.as_text_keycode())
		if event.as_text_keycode().contains("Shift+"):
			var key = event.as_text_keycode().substr(6,-1)
			print(key)
			$shift_animation.play("Shift") 
			$key_press.play(key)
		else:
			if $key_press.is_playing():
				await $key_press.animation_finished 
			$key_press.play(event.as_text_keycode())
