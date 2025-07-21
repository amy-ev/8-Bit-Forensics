extends TextureRect

var day = Global.unlocked +1

var tween_x:Tween
var tween_y:Tween

func _ready() -> void:
	pass
	# "res://assets/evidence/evidence_"+str(day)+".tscn"
	#material.set_shader_parameter("front", load("res://assets/evidence/evidence")) 
	#material.set_shader_parameter("back", load("res://assets/evidence/SD-BACK-x3.png")) 
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.position.x <= (size.x / 2):
			if event.position.y <= (size.y / 2):
				#top left
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property(material,"shader_parameter/x_rot",20.0, 0.2)
				tween_y.tween_property(material,"shader_parameter/y_rot",-20.0, 0.2)
			else:
				#bottom left
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property(material,"shader_parameter/x_rot",-20.0, 0.2)
				tween_y.tween_property(material,"shader_parameter/y_rot",-20.0, 0.2)

		else:
			if event.position.y <= (size.y / 2):
				#top right
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property(material,"shader_parameter/x_rot",20.0,0.2)
				tween_y.tween_property(material,"shader_parameter/y_rot",20.0,0.2)

			else:
				#bottom right
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property(material,"shader_parameter/x_rot",-20.0, 0.2)
				tween_y.tween_property(material,"shader_parameter/y_rot", 20.0, 0.2)
				
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			Global.emit_signal("evidence_collected")
			queue_free()

func _on_mouse_exited() -> void:
	await tween_x.finished and tween_y.finished
	
	tween_x = get_tree().create_tween()
	tween_y = get_tree().create_tween()
	
	tween_x.tween_property(material,"shader_parameter/x_rot", 0.0, 0.3)
	tween_y.tween_property(material,"shader_parameter/y_rot", 0.0, 0.3)


func _on_evidence_boundary_area_entered(area: Area2D) -> void:
	if area.name == "bag":
		mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_evidence_boundary_area_exited(area: Area2D) -> void:
	if area.name == "bag":
		mouse_filter = Control.MOUSE_FILTER_PASS
