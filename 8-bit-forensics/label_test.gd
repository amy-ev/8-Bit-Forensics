extends Node2D

var current_select: Array
var current_rows: Array
var draw_allowed: bool = false

func _ready() -> void:
	Global.connect("metadata_selected", _on_label_selected)

func _on_label_selected(selected:Node):
	var selected_rect = selected.get_node("selected")
	
	for rect in current_select:
		if rect != selected_rect:
			rect.visible = false
	if selected_rect not in current_select:
		current_select.append(selected_rect)
		current_rows.append(selected.text)
		
	if current_select.size() == 2:
		draw_allowed = true
		queue_redraw()
		
func _draw() -> void:
	var pos_middle
	var pos_from = []
	var pos_to = []
	if draw_allowed:
		for label in current_select:
			pos_from.append(label.global_position + Vector2(label.size.x,label.size.y/2))
			pos_to.append((label.global_position + Vector2(label.size.x,label.size.y/2)) + Vector2(80,0))
			for i in pos_to.size():
				draw_dashed_line(pos_from[i], pos_to[i], Color.WHITE, 3.0,3.0)
			print(pos_from)
			print(pos_to)
		pos_middle = (pos_to[0][1] + pos_to[1][1]) / 2
		print("pos_to[0]", pos_to[0], "pos_to[1]", pos_to[1])
		draw_dashed_line(pos_to[0], Vector2(pos_to[0][0],pos_middle),Color.BLACK, 3.0, 3.0)
		draw_dashed_line(pos_to[1], Vector2(pos_to[1][0],pos_middle),Color.BLACK, 3.0, 3.0)
		draw_dashed_line(Vector2(pos_to[0][0],pos_middle),Vector2((pos_to[0][0]+40.0),pos_middle), Color.CRIMSON, 3.0, 3.0 )
		
