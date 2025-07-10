extends NinePatchRect

@onready var _file_metadata = preload("res://file_dialog/load_file.tscn")
@export var current_image: String

var keys_and_values: Array
var current_select: Array
var current_rows: Array

var notif_icon_size = Vector2(27,27)
var draw_allowed: bool = false
var correlates: bool = false
var matches:bool = false
var match_msg:String

var pos_middle: Vector2
var pos_from: Array
var pos_to: Array
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
	correlates = false
	
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
		#coords1.append(pos_middle)
		#coords1.append(Vector2(pos_middle[0] + 100, pos_middle[1]))
		
		# --
		coords2.append(Vector2(pos_from[1]))
		coords2.append(Vector2(pos_to[1]))
		#  |
		coords2.append(Vector2(pos_to[1]))
		coords2.append(pos_middle)
		#   --
		#coords2.append(pos_middle)
		#coords2.append(Vector2(pos_middle[0] + 100, pos_middle[1]))
		
		for i in range(coords1.size() -1):
			var length = coords1[i].distance_to(coords1[i+1])
			segment_lengths.append(length)
			total_length += length
			
		for i in range(coords2.size() -1):
			var length = coords2[i].distance_to(coords2[i+1])
			segment_lengths2.append(length)
			total_length2 += length

		draw_allowed = true
		compare_keys()

	if current_select.size() > 2:
		for rect in current_select:
			rect.visible = false
		current_select.clear()
		current_rows.clear()
		
		draw_allowed = false
		queue_redraw()
		
	for rect in current_select:
		rect.visible = true
		
func compare_keys():
	# create a whole dictionary with each metadata key represented
	#TODO: implement the thumbnail image as a clickable item to compare metadata to visual
	correlates = false
	matches = false
	
	#TODO: maybe move this out of the function
	var compare_dict = {"DateTime":["DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeOriginal":["DateTime","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeDigitized":["DateTime","DateTimeOriginal","GPSTimeStamp","GPSDateStamp"],
					"GPSTimeStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSDateStamp"],
					"GPSDateStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSTimeStamp"],
	 				"Make":["Model","Software","LensMake","LensModel"],
					"Model":["Make","Software","LensMake","LensModel"],
					"Software":["Make","Model","LensMake","LensModel"],
					"LensMake":["Make","Model","Software","LensModel"],
					"LensModel":["Make","Model","Software","LensMake"],
	 				"GPSLongitudeRef":"GPSLongitude",
					"GPSLatitudeRef":"GPSLatitude",
					"GPSLongitude":["GPSLatitude","GPSLongitudeRef"],
					"GPSLatitude":["GPSLongitude","GPSLatitudeRef"]}
					
	var interesting = ["ImageDescription","Copyright","Artist"]
	
	if current_rows.size() == 2:
		var first_key = current_rows[0]
		var second_key = current_rows[1]

		if compare_dict.has(first_key):
			var key_values = compare_dict[first_key]
			
			if typeof(key_values) == TYPE_ARRAY && key_values.has(second_key):
				correlates = true
				
				var value_dict = []
				var json_dict = open_json("res://python_files/metadata.json")
				
				if typeof(json_dict) == TYPE_DICTIONARY:
					if json_dict.has("file_%s" %current_image):
						for node in current_select:
							value_dict.append(json_dict["file_" + current_image][node.get_parent().text])
						
						compare_values(value_dict[0],value_dict[1])
						
				#TODO: NEW ANIMATION CALLED CORRELATES ETC 
				$AnimationPlayer.play("draw_line")
			else:
				$AnimationPlayer.play("no_correlation")
		else:
			$AnimationPlayer.play("no_correlation")
			
	#TODO: either move this to function above or add a ! button to click instead - to act as the second item
	#else:
		#if current_rows.size() == 0:
			#return
		#else:
			#for i in interesting.size():
				#if current_rows[0] == interesting[i]:
					#print("interesting")
					#break
					
#only called on keys that correlate
func compare_values(a,b):
	#TODO: add to this for the other types of metadata
	if current_rows[0].contains("DateTime") || current_rows[1].contains("DateTime"):
		print("date and time")
		
	if current_rows[0].contains("GPSTime") || current_rows[1].contains("GPSTime"):
		if current_rows[0].contains("GPSTime"):
			a = format_gpstime(a)
		else:
			b = format_gpstime(b)
	if a.contains(b) || b.contains(a):
		matches = true
		match_msg = "these dates/times match!"
	else:
		matches = false
		match_msg = "somethings not quite right with these"
	
	print(current_rows[0]," vs ", current_rows[1])
	print(a," vs ",b)
	
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
			
# convert time to match the layout of the other date/times
func format_gpstime(v:String)-> String:
	var regex = RegEx.new()
	regex.compile("[\\(\\)\\s]")
	
	for result in regex.search_all(v):
		v = v.replacen(result.get_string(),"")
	var v_dict = v.split(",",false)
	v_dict[2] = str(ceil(float(v_dict[2])))
	v = ":".join(v_dict)
	return v
	
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
			
	if correlates:
		#TODO RECT SHOWN CHANGES DEPENDING ON WHICH BOOL IS TRUE OR STRING
		var img = Image.load_from_file("res://assets/metadata/exit-x3.png")
		# for a transparent background - add image to tree as a sprite 2d - .texture
		var temp_rect = ImageTexture.create_from_image(img)
		if progress == 1.0:
			#if matches:
			draw_string(ThemeDB.fallback_font,Vector2(coords1[-1][0] + 20,coords1[-1][1] +5),match_msg)
				#draw_string(ThemeDB.fallback_font,Vector2(coords1[-1][0] + 20,coords1[-1][1] +5),"something doesnt match")
		
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
	pos_middle = Vector2()
