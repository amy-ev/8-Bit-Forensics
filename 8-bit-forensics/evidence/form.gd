extends NinePatchRect

func _ready() -> void:
	$columns/column2/continuity/name_label/name.text = Global.form_name
	$columns/column2/continuity/signed_label/signed.text = Global.form_signed
	$columns/column2/continuity/date_label/date.text = Global.form_date

func _on_confirm_pressed() -> void:
	Global.form_name = $columns/column2/continuity/name_label/name.text
	Global.form_signed = $columns/column2/continuity/signed_label/signed.text
	Global.form_date = $columns/column2/continuity/date_label/date.text
	#stop the player if they havent filled out the form
	queue_free()
	#zoom out animation and then queue_free()
	#emit signal to confirm form has been filled
	
