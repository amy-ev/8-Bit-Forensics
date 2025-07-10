extends NinePatchRect

@onready var _file_metadata = preload("res://file_dialog/load_file.tscn")
@onready var _comment = preload("res://pc/comment.tscn")

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
		
	$thumbnail_column/thumbnail/thumbnail_area/thumbnail_shape.disabled = false
	
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
	if self.has_node("comment"):
		self.get_node("comment").queue_free()
	correlates = false
	
	clear_values()
	
	for rect in current_select:
		if rect != selected:
			rect.get_node("selected").visible = false
	if selected not in current_select:
		current_select.append(selected)
		if selected.get_class() == "Label":
			current_rows.append(selected.text)
		else:
			current_rows.append(selected.get_node("label").text)
		
	if current_select.size() == 2:
		var from_pos
		var to_pos
		for label in current_select:
			#print(label.get_node("selected").global_position)
			#print(label.get_node("selected").size.x)
			# to prevent the lines from being off the screen
			if label.global_position.x <= 20:
				pos_from.append(label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x + 318,label.get_node("selected").size.y/2))
				pos_to.append((label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x+ 318 ,label.get_node("selected").size.y/2)) + Vector2(30,0))
				
			elif label.global_position.y <= 30: 
				pos_from.append(Vector2(label.get_node("selected").global_position.x, 30) + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2))
				pos_to.append((Vector2(label.get_node("selected").global_position.x, 30) + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2)) + Vector2(30,0))
			elif label.global_position.y >= 300:
				pos_from.append(Vector2(label.get_node("selected").global_position.x, 300+label.get_node("selected").size.y) + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2))
				pos_to.append((Vector2(label.get_node("selected").global_position.x, 300+label.get_node("selected").size.y) + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2)) + Vector2(30,0))
			else:
				pos_from.append(label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2))
				pos_to.append((label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x,label.get_node("selected").size.y/2)) + Vector2(30,0))
				
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
			rect.get_node("selected").visible = false
		current_select.clear()
		current_rows.clear()
		
		draw_allowed = false
		queue_redraw()
		
	for rect in current_select:
		rect.get_node("selected").visible = true
		
func compare_keys():
	correlates = false
	matches = false
	
	#TODO: maybe move this out of the function
	var compare_dict = {"DateTime":["DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","GPSDateStamp","Thumbnail"],
					"DateTimeOriginal":["DateTime","DateTimeDigitized","GPSTimeStamp","GPSDateStamp","Thumbnail"],
					"DateTimeDigitized":["DateTime","DateTimeOriginal","GPSTimeStamp","GPSDateStamp","Thumbnail"],
					"GPSTimeStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSDateStamp","Thumbnail"],
					"GPSDateStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","Thumbnail"],
	 				"Make":["Model","Software","LensMake","LensModel"],
					"Model":["Make","Software","LensMake","LensModel"],
					"Software":["Make","Model","LensMake","LensModel"],
					"LensMake":["Make","Model","Software","LensModel"],
					"LensModel":["Make","Model","Software","LensMake"],
	 				"GPSLongitudeRef":["GPSLongitude"],
					"GPSLatitudeRef":["GPSLatitude"],
					"GPSLongitude":["GPSLatitude","GPSLongitudeRef"],
					"GPSLatitude":["GPSLongitude","GPSLatitudeRef"],
					"Thumbnail":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"]}
	
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
						for node in current_select.size():
							if current_select[node].get_class() == "Label":
								value_dict.append(json_dict["file_" + current_image][current_select[node].text])
							else:
								#TODO: maybe change this to get a value from another json file eg photo2 = sunny
								value_dict.append(current_select[node].get_node("label").text)
								#value_dict["Thumbnail"] = node.get_node("label").text
						
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

	if current_rows[0].contains("DateTime") || current_rows[1].contains("DateTime") || current_rows[0].contains("GPSTime") || current_rows[1].contains("GPSTime"):
		print("date and time")
		
		if current_rows[0].contains("GPSTime"):
			a = format_gpstime(a)
		elif current_rows[1].contains("GPSTime"):
			b = format_gpstime(b)
			
		if a.contains(b) || b.contains(a):
			matches = true
			match_msg = "these dates/times match!"
		else:
			matches = false
			match_msg = "somethings not quite right with these"
			
		#TODO: 
		if current_rows[0].contains("Thumbnail") || current_rows[1].contains("Thumbnail"):
			match_msg = "needs to be worked on"
			
		if current_rows[0].contains("GPSTime") && current_rows[1].contains("GPSDate") || current_rows[1].contains("GPSTime") && current_rows[0].contains("GPSDate"):
			match_msg = a + " " + b

	elif current_rows[0].contains("Make") || current_rows[1].contains("Make") || current_rows[0].contains("Model") || current_rows[1].contains("Model"):
		print("make and model")
		
		if current_rows[0].contains("Make") && current_rows[1].contains("Model"):
			if a.contains("Apple") && b.contains("iP"):
					match_msg = "makes sense"
					
		elif current_rows[1].contains("Make") && current_rows[0].contains("Model"):
			if b.contains("Apple") && a.contains("iP"):
					match_msg = "makes sense"
		
		elif  current_rows[0].contains("Make") && current_rows[1].contains("Make"):
			if a.contains(b) || b.contains(a):
				matches = true
				match_msg = "the makes match"
				
		elif  current_rows[0].contains("Model") && current_rows[1].contains("Model"):
			if a.contains(b) || b.contains(a):
				matches = true
				match_msg = "the models match"
		else:
			match_msg = "correlates"

	elif current_rows[0].contains("GPS") || current_rows[1].contains("GPS"): #will be true either way - only gps matches with gps
		if current_rows[0].contains("Ref"):
			match_msg = a + " " + b
		elif current_rows[1].contains("Ref"):
			match_msg = b + " " + a
		
		if current_rows[0].contains("Longitude") && current_rows[1].contains("Latitude") || current_rows[0].contains("Latitude") && current_rows[1].contains("Longitude"):
			match_msg = "long vs lat"
	
	#print(current_rows[0]," vs ", current_rows[1])
	#print(a," vs ",b)
	
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
	for i in v_dict.size():
		v_dict[i] = str(ceili(float(v_dict[i])))
		while int(v_dict[i]) >= 100:
			v_dict[i] = str(int(v_dict[i]) / 10)
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
			var comment = _comment.instantiate()
			add_child(comment)
			comment.text = match_msg
			comment.position = Vector2(coords1[-1][0] + 20,coords1[-1][1]- comment.size.y /2)
			#draw_string(ThemeDB.fallback_font,Vector2(coords1[-1][0] + 20,coords1[-1][1] +5),match_msg)
			
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


func _on_thumbnail_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed():
		Global.metadata_selected.emit($thumbnail_column/thumbnail)
