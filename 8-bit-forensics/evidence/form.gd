extends CanvasLayer

@onready var _dialogue = preload("res://dialogue/redirect_dialogue.tscn")

func _ready() -> void:
	print(get_parent())
	if get_parent().name == "opened_bag":
		print(Global.form_name)
		$evidence_form/columns/column2/continuity/name_label/name.text = Global.form_name
		$evidence_form/columns/column2/continuity/signed_label/signed.text = Global.form_signed
		$evidence_form/columns/column2/continuity/date_label/date.text = Global.form_date
		
		$evidence_form/columns/column2/continuity/name_label/name.editable = false
		$evidence_form/columns/column2/continuity/signed_label/signed.editable = false
		$evidence_form/columns/column2/continuity/date_label/date.editable = false
	else: 
		$evidence_form/columns/column2/continuity/name_label/name.text = ""
		$evidence_form/columns/column2/continuity/signed_label/signed.text = ""
		$evidence_form/columns/column2/continuity/date_label/date.text = ""
		
		$evidence_form/columns/column2/continuity/name_label/name.editable = true
		$evidence_form/columns/column2/continuity/signed_label/signed.editable = true
		$evidence_form/columns/column2/continuity/date_label/date.editable = true
	#if Global.is_first_bag:
		#$columns/column2/continuity/name_label/name.text = Global.form_name
		#$columns/column2/continuity/signed_label/signed.text = Global.form_signed
		#$columns/column2/continuity/date_label/date.text = Global.form_date

func _on_confirm_pressed() -> void:
	print(Global.form_name)
	var form_name = $evidence_form/columns/column2/continuity/name_label/name.text
	var form_signed = $evidence_form/columns/column2/continuity/signed_label/signed.text
	var form_date = $evidence_form/columns/column2/continuity/date_label/date.text
	
	if get_parent().name == "evidence_bag":
		if !form_name.is_empty() && !form_signed.is_empty() && !form_date.is_empty():
			Global.form_name = form_name
			Global.form_signed = form_signed
			Global.form_date = form_date
			get_parent().form_filled = true
			queue_free()
			Global.is_first_bag = false
		else:
			var dialogue = _dialogue.instantiate()
			add_child(dialogue)
			dialogue.start("fill all")
			
	elif get_parent().name == "new_bag":
		if form_name != Global.form_name || form_signed != Global.form_signed || form_date != Global.form_date:
			var dialogue = _dialogue.instantiate()
			add_child(dialogue)
			dialogue.start("does not match")
		else:
			var dialogue = load("res://dialogue/dialogue_display.tscn").instantiate()
			dialogue.get_node("npc_normal").set_visible(false)
			dialogue.get_node("npc_good").set_visible(true)
			var animation = get_parent().get_node("animation")
			animation.play("seal")
			set_visible(false)
			await animation.animation_finished
			#TODO: reseal animation
			queue_free()
			get_parent().add_child(dialogue)
			dialogue.start("crime ! time to end day")

			#trigger dialogue to end day
	elif get_parent().name == "opened_bag":
		queue_free()
