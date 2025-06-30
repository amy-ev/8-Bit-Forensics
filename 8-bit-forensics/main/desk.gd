extends TextureRect

var day = Global.unlocked + 1

func _ready() -> void:
	# change evidence item to match the texture of evidence_1, evidence_2 etc
	$evidence.texture_normal = load("res://assets/office/btn-x3.png")


func _on_pc_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://pc/pc_screen.tscn")


func _on_evidence_pressed() -> void:
	var evidence_item = load("res://main/evidence.tscn")
	add_child(evidence_item.instantiate())
