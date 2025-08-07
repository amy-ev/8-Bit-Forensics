extends NinePatchRect

func _ready() -> void:
	get_parent().get_node("hex_viewer/load").disabled = true
	get_parent().get_node("hex_viewer/save").disabled = true
	
func _on_exit_pressed() -> void:
	get_parent().get_node("hex_viewer/load").disabled = false
	get_parent().get_node("hex_viewer/save").disabled = false
	queue_free()
