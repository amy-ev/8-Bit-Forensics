extends TextureRect

@onready var _opened_bag = preload("res://evidence/opened_bag.tscn")
@onready var _new_bag = preload("res://evidence/new_bag.tscn")
@onready var _moveable_evidence = preload("res://evidence/moveable_evidence.tscn")

func _ready() -> void:
	if !Global.is_first_bag:
		$evidence_bag.queue_free()
		$evidence.queue_free()
		add_child(_opened_bag.instantiate(),true)
		add_child(_new_bag.instantiate(), true)
		add_child(_moveable_evidence.instantiate(),true)
	get_parent().get_node("pc/pc_area/pc_shape").disabled = true
	get_parent().get_node("coffee_cup/coffee/coffee_shape").disabled = true
	
func _on_back_pressed() -> void:
	queue_free()
	get_parent().get_node("pc/pc_area/pc_shape").disabled = false
	get_parent().get_node("coffee_cup/coffee/coffee_shape").disabled = false
