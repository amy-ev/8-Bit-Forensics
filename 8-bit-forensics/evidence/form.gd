extends CanvasLayer

@onready var _dialogue = preload("res://dialogue/redirect_dialogue.tscn")
@onready var _name = $evidence_form/columns/column2/continuity/name_label/name
@onready var _signed = $evidence_form/columns/column2/continuity/signed_label/signed
@onready var _date = $evidence_form/columns/column2/continuity/date_label/date

func _ready() -> void:
	print(get_parent())
	if get_parent().name == "opened_bag":
		print(Global.form_name)
		_name.text = Global.form_name
		_signed.text = Global.form_signed
		_date.text = Global.form_date
		
		_name.editable = false
		_signed.editable = false
		_date.editable = false
		
	else: 
		_name.text = ""
		_signed.text = ""
		_date.text = ""
		
		_name.editable = true
		_signed.editable = true
		_date.editable = true

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
			Global.emit_signal("form_filled")
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
			
			var animation = get_parent().get_node("animation")
			animation.play("seal")
			set_visible(false)
			await animation.animation_finished
			
			queue_free()
			get_parent().add_child(dialogue)
			dialogue.start("crime ! time to end day")

			#trigger dialogue to end day
	elif get_parent().name == "opened_bag":
		queue_free()
