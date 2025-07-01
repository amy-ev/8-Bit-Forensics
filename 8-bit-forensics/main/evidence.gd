extends TextureRect

var day = Global.unlocked +1

func _ready() -> void:
	# "res://assets/evidence/evidence_"+str(day)+".tscn"
	#$evidence.texture = load("res://assets/office/btn-x3.png")
	$evidence.material
func _on_back_pressed() -> void:
	queue_free()


func _on_collect_pressed() -> void:
	$evidence.queue_free()
	Global.evidence_collected.emit()
