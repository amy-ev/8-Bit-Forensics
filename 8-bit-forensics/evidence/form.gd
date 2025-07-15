extends NinePatchRect


func _on_confirm_pressed() -> void:
	#stop the player if they havent filled out the form
	queue_free()
	#zoom out animation and then queue_free()
	#emit signal to confirm form has been filled
	
