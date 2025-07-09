extends NinePatchRect

@onready var _file_metadata = preload("res://file_dialog/load_file.tscn")
@export var current_image: String

var keys_and_values: Array
var current_select: Array
var current_rows: Array


var draw_allowed: bool = false
var pos_middle
var pos_from = []
var pos_to = []
var coords1: PackedVector2Array
var coords2: PackedVector2Array

@export var progress = 0.0 
var total_length = 0.0
var segment_lengths = []

var total_length2 = 0.0
var segment_lengths2 = []
var scroll_value

func _ready() -> void:
	Global.connect("metadata_selected", _on_label_selected)

func _on_select_pressed() -> void:
	var file_metadata = _file_metadata.instantiate()
	add_child(file_metadata)
	
	await file_metadata.tree_exited
	
	for hbox in $scroll/data_container.get_children():
		keys_and_values.append(hbox)
	
func _on_exit_pressed() -> void:
	queue_free()
	
func _process(delta: float) -> void:
	if $backgrounds.minimum_size_changed:
		$backgrounds.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - 135
	if $backgrounds/value_background.minimum_size_changed:
		$backgrounds/value_background.custom_minimum_size.x = $"../metadata_window".custom_minimum_size.x - (135 + $"backgrounds/key_background".custom_minimum_size.x)
	if $scroll.minimum_size_changed:
		$scroll.custom_minimum_size.x = $backgrounds.custom_minimum_size.x - 6
		$scroll/data_container.custom_minimum_size.x = $scroll.custom_minimum_size.x - 8
	if !keys_and_values.is_empty():
		
		for hbox in keys_and_values.size():
			if keys_and_values[hbox].minimum_size_changed:
				keys_and_values[hbox].get_child(0).custom_minimum_size.x = $backgrounds/key_background.custom_minimum_size.x - 3
				keys_and_values[hbox].get_child(0).get_node("selected").custom_minimum_size.x = ($backgrounds/key_background.custom_minimum_size.x + $backgrounds/value_background.custom_minimum_size.x)
				keys_and_values[hbox].get_child(0).get_node("select/select_shape").shape.size.x = ($backgrounds/key_background.custom_minimum_size.x + $backgrounds/value_background.custom_minimum_size.x)
				keys_and_values[hbox].get_child(1).custom_minimum_size.x = $backgrounds/value_background.custom_minimum_size.x - 3

func _on_label_selected(selected:Node):
	var selected_rect = selected.get_node("selected")
	
	clear_values()
	
	for rect in current_select:
		if rect != selected_rect:
			rect.visible = false
	if selected_rect not in current_select:
		current_select.append(selected_rect)
		current_rows.append(selected.text)
		
	if current_select.size() == 2:
		var from_pos
		var to_pos
		for label in current_select:
			# to prevent the lines from being off the screen
			if label.get_parent().global_position.y <= 30: 
				pos_from.append(Vector2(label.global_position.x, 30) + Vector2(label.size.x,label.size.y/2))
				pos_to.append((Vector2(label.global_position.x, 30) + Vector2(label.size.x,label.size.y/2)) + Vector2(80,0))
			elif label.get_parent().global_position.y >= 300:
				pos_from.append(Vector2(label.global_position.x, 300+label.size.y) + Vector2(label.size.x,label.size.y/2))
				pos_to.append((Vector2(label.global_position.x, 300+label.size.y) + Vector2(label.size.x,label.size.y/2)) + Vector2(80,0))
			else:
				pos_from.append(label.global_position + Vector2(label.size.x,label.size.y/2))
				pos_to.append((label.global_position + Vector2(label.size.x,label.size.y/2)) + Vector2(80,0))
				
		pos_middle = Vector2(pos_to[0][0],(pos_to[0][1] + pos_to[1][1]) / 2)
		
		# --
		coords1.append(Vector2(pos_from[0]))
		coords1.append(Vector2(pos_to[0]))
		#  |
		coords1.append(Vector2(pos_to[0]))
		coords1.append(pos_middle)
		#   --
		coords1.append(pos_middle)
		coords1.append(Vector2(pos_middle[0] + 100, pos_middle[1]))
		
		# --
		coords2.append(Vector2(pos_from[1]))
		coords2.append(Vector2(pos_to[1]))
		#  |
		coords2.append(Vector2(pos_to[1]))
		coords2.append(pos_middle)
		#   --
		coords2.append(pos_middle)
		coords2.append(Vector2(pos_middle[0] + 100, pos_middle[1]))
		
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

	if current_select.size() > 2:
		for rect in current_select:
			rect.visible = false
		current_select.clear()
		current_rows.clear()
		
		draw_allowed = false
		queue_redraw()
		
	for rect in current_select:
		rect.visible = true

func open_json(file_path):
	if FileAccess.file_exists(file_path):

		var metadata = FileAccess.open(file_path, FileAccess.READ)
		
		if FileAccess.get_open_error() != OK:
			print("could not open file: ", metadata.get_open_error())
	
		var json = JSON.new()
		var error = json.parse(metadata.get_as_text())
		if error == OK:
			var json_dict = json.data
			
			metadata.close()
			return json_dict
		else:
			print("error code:" , error)
			metadata.close()

func _on_flag_pressed() -> void:
	# create a whole dictionary with each metadata key represented
	#TODO: implement the thumbnail image as a clickable item to compare metadata to visual
	var matches = {"DateTime":["DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeOriginal":["DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeDigitized":["GPSTimeStamp","GPSDateStamp"],
					"GPSTimeStamp":["GPSDateStamp"],
	 				"Make":["Model","Software","LensMake","LensModel"],
					"Model":["Software","LensMake","LensModel"],
					"Software":["LensMake","LensModel"],
					"LensMake":["LensModel"],
	 				"GPSLongitudeRef":"GPSLongitude",
					"GPSLatitudeRef":"GPSLatitude",
					 "GPSLongitude":"GPSLatitude"}
					
	var interesting = ["ImageDescription","Copyright","Artist"]
	
	if current_rows.size() == 2:
		for i in current_rows.size():
			var row = current_rows[i]
			for j in current_rows.size():
				var row_check = current_rows[j]
				
				if matches.has(row):
					var item = matches[row]
					if typeof(item) == TYPE_STRING && item == row_check || typeof(item) == TYPE_ARRAY && item.has(row_check):
						print("correlate")
						
	else:
		if current_rows.size() == 0:
			return
		else:
			for i in interesting.size():
				if current_rows[0] == interesting[i]:
					print("interesting")
					break
					
	var json_dict = open_json("res://python_files/metadata.json")
	if typeof(json_dict) == TYPE_DICTIONARY:
		if json_dict.has("file_%s" %current_image):
			for i in current_select:
				print(json_dict["file_" + current_image][i.get_parent().text])

func _draw() -> void:

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
	
	
func _update_progress(value:float):
	progress = value
	queue_redraw()

func clear_values():
	coords1.clear()
	coords2.clear()
	segment_lengths.clear()
	segment_lengths2.clear()
	pos_from.clear()
	pos_to.clear()
	progress = 0.0
	total_length = 0.0
	total_length2 = 0.0
	pos_middle = 0.0
