extends RigidBody2D

var is_picked_up = false
var form_filled = false

var evidence_bagged:bool
var bag_bagged:bool

var _form = preload("res://evidence/form.tscn")

func _on_bag_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if name == "evidence_bag":
		if event is InputEventMouseButton and event.button_index == 1:
			if event.is_pressed():
				is_picked_up = true
			if event.is_released():
				is_picked_up = false

func _on_cut_section_area_entered(area: Area2D) -> void:
	if area.name == "blades":
		if form_filled:
			if area.get_parent().is_picked_up:
				area.get_parent().is_picked_up = false
				$animation.play("open")
				area.get_parent().get_node("animation").play("cut")
				var tween = create_tween()
				tween.tween_property(area.get_parent(),"global_position", Vector2(area.get_parent().global_position.x - $bag/collision.shape.size.x, area.get_parent().global_position.y),0.5)
				await $animation.animation_finished
				$bag/collision.disabled = false
				$cut_section.queue_free()
				area.get_parent().queue_free()
		else:
			pass

func _physics_process(delta: float) -> void:
	if is_picked_up:
		var target = get_global_mouse_position() - ($bag/collision.shape.size / 2)
		move_and_collide(target - global_position)

func _on_form_section_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.get_parent().name == "pen":
		var form = _form.instantiate()
		add_child(form)
		area.get_parent().queue_free()


func _on_bag_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "moveable":
		evidence_bagged = true
	if area.name == "bag":
		bag_bagged = true
		
	if evidence_bagged && bag_bagged:
		print("both inside")
		$form_section/drop_point.set_deferred("disabled",false)
		#$form_section/drop_point.disabled = false
		#TODO: SEAL BAG
		# seal the bag - play animation
		#dialogue to fill in form 


func _on_bag_area_exited(area: Area2D) -> void:
	print(area.name)
	if area.name == "moveable":
		evidence_bagged = false
	if area.name == "bag":
		bag_bagged = false
