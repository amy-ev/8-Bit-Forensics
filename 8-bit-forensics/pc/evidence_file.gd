extends CanvasLayer

@export var md5_hash: String
var day = Global.unlocked + 1

func _on_button_pressed() -> void:
	var evidence_name = "evidence_item_"+ str(day)
	md5_hash = evidence_name.md5_text()
	
	$Control/ColorRect2/HBoxContainer/MD5_label.visible = true
	$Control/ColorRect2/HBoxContainer/MD5_hash.text = md5_hash
