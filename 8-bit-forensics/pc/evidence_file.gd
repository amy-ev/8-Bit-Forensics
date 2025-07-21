extends Control

@export var md5_hash: String
var day = Global.unlocked + 1

func _on_button_pressed() -> void:
	var evidence_name = "evidence_item_"+ str(day)
	md5_hash = evidence_name.md5_text()
	
	$ColorRect2/HBoxContainer/MD5_label.visible = true
	$ColorRect2/HBoxContainer/MD5_hash.text = md5_hash
