extends TextureRect

var day = Global.unlocked +1

var tween_x:Tween
var tween_y:Tween

func _ready() -> void:
	# "res://assets/evidence/evidence_"+str(day)+".tscn"
	$evidence.material.set_shader_parameter("front", load("res://assets/evidence/SD-x3.png")) 

func _on_back_pressed() -> void:
	queue_free()


func _on_collect_pressed() -> void:
	$evidence.queue_free()
	Global.evidence_collected.emit()

func _on_evidence_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		if event.position.x <= ($evidence.size.x / 2):
			if event.position.y <= ($evidence.size.y / 2):
				#top left
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property($evidence.material,"shader_parameter/x_rot",20.0, 0.2)
				tween_y.tween_property($evidence.material,"shader_parameter/y_rot",-20.0, 0.2)
			else:
				#bottom left
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property($evidence.material,"shader_parameter/x_rot",-20.0, 0.2)
				tween_y.tween_property($evidence.material,"shader_parameter/y_rot",-20.0, 0.2)

		else:
			if event.position.y <= ($evidence.size.y / 2):
				#top right
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property($evidence.material,"shader_parameter/x_rot",20.0,0.2)
				tween_y.tween_property($evidence.material,"shader_parameter/y_rot",20.0,0.2)

			else:
				#bottom right
				if tween_x || tween_y:
					tween_x.kill()
					tween_y.kill()
				tween_x = create_tween()
				tween_y = create_tween()
				
				tween_x.tween_property($evidence.material,"shader_parameter/x_rot",-20.0, 0.2)
				tween_y.tween_property($evidence.material,"shader_parameter/y_rot", 20.0, 0.2)

func _on_evidence_mouse_exited() -> void:
	await tween_x.finished and tween_y.finished
	
	tween_x = get_tree().create_tween()
	tween_y = get_tree().create_tween()
	
	tween_x.tween_property($evidence.material,"shader_parameter/x_rot", 0.0, 0.3)
	tween_y.tween_property($evidence.material,"shader_parameter/y_rot", 0.0, 0.3)
