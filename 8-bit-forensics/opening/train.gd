extends Control



func _on_animation_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://main/desk.tscn")
