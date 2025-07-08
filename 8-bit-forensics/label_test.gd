extends Node2D

var current_select: Array
var current_rows: Array
var draw_allowed: bool = false

var pos_middle
var pos_from = []
var pos_to = []
var coords1: PackedVector2Array=[]
var coords2:PackedVector2Array = []

@export var progress = 0.0 
var total_length = 0.0
var segment_lengths = []

var total_length2 = 0.0
var segment_lengths2 = []

func _update_progress(value:float):
	progress = value
	queue_redraw()

func _ready() -> void:
	Global.connect("metadata_selected", _on_label_selected)

func _on_label_selected(selected:Node):
	var selected_rect = selected.get_node("selected")
	coords1 =[]
	coords2 =[]
	progress = 0
	total_length = 0
	segment_lengths = []
	total_length2 = 0
	segment_lengths2 = []
	
	for rect in current_select:
		if rect != selected_rect:
			rect.visible = false
	if selected_rect not in current_select:
		current_select.append(selected_rect)
		current_rows.append(selected.text)
		
	if current_select.size() == 2:
		for label in current_select:
			pos_from.append(label.global_position + Vector2(label.size.x,label.size.y/2))
			pos_to.append((label.global_position + Vector2(label.size.x,label.size.y/2)) + Vector2(80,0))
		pos_middle = Vector2(pos_to[0][0],(pos_to[0][1] + pos_to[1][1]) / 2)
		
		coords1.append(Vector2(pos_from[0]))
		coords1.append(Vector2(pos_to[0]))
		coords1.append(Vector2(pos_to[0]))
		coords1.append(pos_middle)
		coords1.append(pos_middle)
		coords1.append(Vector2(pos_middle[0] + 100, pos_middle[1]))
		
		coords2.append(Vector2(pos_from[1]))
		coords2.append(Vector2(pos_to[1]))
		coords2.append(Vector2(pos_to[1]))
		coords2.append(pos_middle)
		
		for i in range(coords1.size() -1):
			var length = coords1[i].distance_to(coords1[i+1])
			segment_lengths.append(length)
			total_length += length
			
		for i in range(coords2.size() -1):
			var length = coords2[i].distance_to(coords2[i+1])
			segment_lengths2.append(length)
			total_length2 += length

		draw_allowed = true
		$AnimationPlayer.play("draw_line")

	
func _draw() -> void:
	var sliced1 =[]
	var sliced2 = []
	if draw_allowed:

		var accum = 0.0
		var current_length = progress * total_length
		
		for i in range(coords1.size()-1):
			var p1 = coords1[i]
			var p2 = coords1[i+1]
			var seg_len = segment_lengths[i]
			if accum + seg_len <= current_length:
				draw_dashed_line(p1,p2,Color.WHITE, 3.0)
			elif accum < current_length:
				var t = (current_length - accum) / seg_len
				var partial_point = p1.lerp(p2,t)
				draw_dashed_line(p1,partial_point,Color.WHITE,3.0)
				break
			else:
				break
			accum += seg_len
			
		var accum2 = 0.0
		var current_length2 = progress * total_length2
		
		for i in range(coords2.size()-1):
			var p1 = coords2[i]
			var p2 = coords2[i+1]
			var seg_len = segment_lengths2[i]
			if accum2 + seg_len <= current_length:
				draw_dashed_line(p1,p2,Color.WHITE, 3.0)
			elif accum2 < current_length2:
				var t = (current_length2 - accum2) / seg_len
				var partial_point = p1.lerp(p2,t)
				draw_dashed_line(p1,partial_point,Color.WHITE,3.0)
				break
			else:
				break
			accum2 += seg_len
		
		#for i in range(0, coords1.size(),2):
			#if i + 1 < coords1.size():
				#sliced1.append(coords1.slice(i,i+2))
		#for i in range(0, coords2.size(),2):
			#if i + 1 < coords2.size():
				#sliced2.append(coords2.slice(i,i+2))
						#
		#for line in sliced1.size():
			#draw_dashed_line(sliced1[line][0], sliced1[line][1], Color.WHITE, 3.0, 3.0)
		#for line in sliced2.size():
			#draw_dashed_line(sliced2[line][0], sliced2[line][1], Color.WHITE, 3.0, 3.0)
		#
		
		
		#var vec_coords1 = array_to_Vector2Array(coords1)
		#var vec_coords2 = array_to_Vector2Array(coords2)
		#draw_multiline(vec_coords1, Color.WHITE, 3.0)
		#draw_polyline(vec_coords2, Color.WHITE, 3.0)
		#draw_dashed_line(Vector2(start_x[0],pos_from[0][1]), Vector2(current_x1, pos_to[0][1]), Color.BLACK, 3.0,3.0)
		#draw_dashed_line(Vector2(start_x[1],pos_from[1][1]), Vector2(current_x2, pos_to[1][1]), Color.BLACK, 3.0,3.0)
		#while current_x1 < max_x:
			#end_x[0] = end_x[0] + 1

			#pos_middle = (pos_to[0][1] + pos_to[1][1]) / 2
			#draw_dashed_line(Vector2(start_x[3],pos_from[3][1]), Vector2(current_x4, pos_to[3][1]), Color.BLACK, 3.0,3.0)
		#print("pos_to[0]", pos_to[0], "pos_to[1]", pos_to[1])
		#draw_dashed_line(pos_to[0], Vector2(pos_to[0][0],pos_middle),Color.BLACK, 3.0, 3.0)
		#draw_dashed_line(pos_to[1], Vector2(pos_to[1][0],pos_middle),Color.BLACK, 3.0, 3.0)
		#draw_dashed_line(Vector2(pos_to[0][0],pos_middle),Vector2((pos_to[0][0]+40.0),pos_middle), Color.CRIMSON, 3.0, 3.0 )
		
