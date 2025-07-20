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
			print("hello")
			var dialogue = _dialogue.instantiate()
			add_child(dialogue)
			dialogue.start("fill all")
	elif get_parent().name == "new_bag":
		if form_name != Global.form_name:
			print("does not match")
		else:
			print("matches original")
			queue_free()
	elif get_parent().name == "opened_bag":
		#$evidence_form/columns/column2/continuity/name_label/name.text = Global.form_name
		queue_free()

	#Global.form_signed = form_signed
	#Global.form_date = form_date
	
	#stop the player if they havent filled out the form
	#queue_free()
	#zoom out animation and then queue_free()
	#emit signal to confirm form has been filled
	
