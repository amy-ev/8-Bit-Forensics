extends NinePatchRect

@onready var _load_files = preload("res://file_dialog/load_file.tscn")
@onready var pc = get_parent().get_parent()

@export var current_image: String

var font: FontFile

var FONT_SIZE:= 8
var FONT_COLOUR:= Color(0.932, 0.863, 0.767)

var keys_and_values: Array
var current_select: Array
var current_rows: Array

var draw_allowed: bool = false
var correlates: bool = false
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

var GPS_noticed_1:bool
var GPS_noticed_2:bool
var GPS_noticed_3:bool
var GPS_noticed_4:bool

var date_time_noticed_1:bool
var date_time_noticed_2:bool
var date_time_noticed_3:bool
var date_time_noticed_4:bool

var model_noticed_1:bool
var model_noticed_2:bool
var model_noticed_3:bool
var model_noticed_4:bool 

var make_noticed_1:bool
var software_noticed_1:bool
var description_noticed_1:bool

var artist_noticed_1:bool
var artist_noticed_2:bool

var lens_noticed_1:bool
var time_noticed:bool
var GPS_and_time_compared:bool
var photoshop_noticed:bool

var selected_img:PackedByteArray

func _ready() -> void:
	font = preload("res://8-bit-forensics.ttf")
	Global.connect("metadata_selected", _on_label_selected)

func _on_select_pressed() -> void:
	var load_files = _load_files.instantiate()
	add_child(load_files)
	
	await load_files.tree_exited
	
	for hbox in $scroll/data_container.get_children():
		keys_and_values.append(hbox)
	selected_img = Global.get_image(Global.user_path + "evidence_files/" + Global.selected_file)

	
func _on_exit_pressed() -> void:
	queue_free()
	
func _process(delta: float) -> void:
	if !keys_and_values.is_empty():
		
		for hbox in keys_and_values.size():
			if keys_and_values[hbox].minimum_size_changed:
				keys_and_values[hbox].get_child(0).custom_minimum_size.x = $backgrounds/key_background.custom_minimum_size.x 
				keys_and_values[hbox].get_child(0).get_node("selected").custom_minimum_size.x = 165
				keys_and_values[hbox].get_child(0).get_node("select/select_shape").shape.size.x = 165
				keys_and_values[hbox].get_child(1).custom_minimum_size.x = $backgrounds/value_background.custom_minimum_size.x 

func _on_label_selected(selected:Node):
	if has_node("comment"):
		remove_child(get_node("comment"))

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
		for label in current_select:
			if label.global_position.y <= 45: 
				pos_from.append(Vector2(label.get_node("selected").global_position.x, 20) + Vector2(label.get_node("selected").size.x/3,2))
				pos_to.append((Vector2(label.get_node("selected").global_position.x, 20) + Vector2(label.get_node("selected").size.x/3,2)) + Vector2(16,0))
			elif label.global_position.y >= 148:
				pos_from.append(Vector2(label.get_node("selected").global_position.x, 142) + Vector2(label.get_node("selected").size.x/3,2))
				pos_to.append((Vector2(label.get_node("selected").global_position.x, 142) + Vector2(label.get_node("selected").size.x/3,2)) + Vector2(16,0))
			else:
				pos_from.append(label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x/3,2)- Vector2(0,label.get_node("selected").size.y*2))
				pos_to.append((label.get_node("selected").global_position + Vector2(label.get_node("selected").size.x/3,2)- Vector2(0,label.get_node("selected").size.y*2)) + Vector2(16,0))

		pos_middle = Vector2(pos_to[0][0],(pos_to[0][1] + pos_to[1][1]) / 2)

		# --
		coords1.append(Vector2(pos_from[0]))
		coords1.append(Vector2(pos_to[0]))
		#  |
		coords1.append(Vector2(pos_to[0]))
		coords1.append(pos_middle)

		# --
		coords2.append(Vector2(pos_from[1]))
		coords2.append(Vector2(pos_to[1]))
		#  |
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

	#TODO: maybe move this out of the function
	var compare_dict = {"DateTime":["DateTimeOriginal","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeOriginal":["DateTime","DateTimeDigitized","GPSTimeStamp","GPSDateStamp"],
					"DateTimeDigitized":["DateTime","DateTimeOriginal","GPSTimeStamp","GPSDateStamp"],
					"GPSTimeStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSDateStamp"],
					"GPSDateStamp":["DateTime","DateTimeOriginal","DateTimeDigitized","GPSTimeStamp"],
	 				"Make":["Model","Software","LensMake","LensModel","ImageDescription"],
					"Model":["Make","Software","LensMake","LensModel","ImageDescription"],
					"Software":["Make","Model","LensMake","LensModel"],
					"LensMake":["Make","Model","Software","LensModel"],
					"LensModel":["Make","Model","Software","LensMake"],
					"LensSpecification":["FocalLength"],
					"FocalLength":["LensSpecification"],
	 				"GPSLongitudeRef":["GPSLongitude"],
					"GPSLatitudeRef":["GPSLatitude"],
					"GPSLongitude":["GPSLatitude","GPSLongitudeRef"],
					"GPSLatitude":["GPSLongitude","GPSLatitudeRef"],
					"GPSAltitude":["GPSAltitudeRef"],
					"GPSAltitudeRef":["GPSAltitude"],
					"Artist":["ImageDescription","Copyright"],
					"ImageDescription":["Make","Model","Artist"],
					"Copyright":["Artist"]}

	if current_rows.size() == 2:
		var first_key = current_rows[0]
		var second_key = current_rows[1]

		if compare_dict.has(first_key):
			var key_values = compare_dict[first_key]
			
			if typeof(key_values) == TYPE_ARRAY && key_values.has(second_key):
				correlates = true
				
				var value_dict = []
				var json_dict = open_json("user://python_files/metadata.json")
				
				if typeof(json_dict) == TYPE_DICTIONARY:
					if json_dict.has("file_%s" %current_image):
						for node in current_select.size():
							if current_select[node].get_class() == "Label":
								value_dict.append(json_dict["file_" + current_image][current_select[node].text])
							else:
								#TODO: maybe change this to get a value from another json file eg photo2 = sunny
								value_dict.append(current_select[node].get_node("label").text)
						
						compare_values(value_dict[0],value_dict[1])
						
				#TODO: NEW ANIMATION CALLED CORRELATES ETC 
				$AnimationPlayer.play("draw_line")
			else:
				$AnimationPlayer.play("no_correlation")
		else:
			$AnimationPlayer.play("no_correlation")
			
func compare_values(a,b):

	if current_rows[0].contains("DateTime") || current_rows[1].contains("DateTime") || current_rows[0].contains("GPSTime") || current_rows[1].contains("GPSTime"):
		print("date and time")
		if current_rows[0] == "DateTime" && (current_rows[1].contains("DateTimeOriginal") || current_rows[1].contains("DateTimeDigitized")) || current_rows[1] == "DateTime" && (current_rows[0].contains("DateTimeOriginal") || current_rows[0].contains("DateTimeDigitized")):
			if selected_img == Global.img1:
				if !date_time_noticed_1:
					Global.img1_count += 1
					get_parent().get_node("Label").text = str(Global.img1_count)
					date_time_noticed_1 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
			
		if (current_rows[0] == "DateTimeOriginal" && current_rows[1] == "DateTimeDigitized") || (current_rows[1] == "DateTimeOriginal" && current_rows[0] == "DateTimeDigitized"):
			if selected_img == Global.img2:
				if !date_time_noticed_2:
					Global.img2_count += 1
					get_parent().get_node("Label").text = str(Global.img2_count)
					date_time_noticed_2 = true
					
					if finished_image_metadata():
							print("done!")
							#TODO: FINISH
							
		if current_rows[0].contains("GPSTime"):
			a = format_gpstime(a)
			
		elif current_rows[1].contains("GPSTime"):
			b = format_gpstime(b)
			
		if current_rows[0].contains("GPSTime") && current_rows[1].contains("GPSDate") || current_rows[1].contains("GPSTime") && current_rows[0].contains("GPSDate"):
			match_msg = a + " " + b
			
		if a.contains(b) || b.contains(a):
			match_msg = "these dates/times match!"
			
		else:
			match_msg = "somethings not quite right with these"
			if current_rows[0].contains("GPSTime") && current_rows[1].contains("DateTime") || current_rows[0].contains("DateTime") && current_rows[1].contains("GPSTime"):

				if selected_img == Global.img3:
					if !date_time_noticed_3:
						_dialogue("m5.0")

						Global.img3_count += 1
						get_parent().get_node("Label").text = str(Global.img3_count)
						date_time_noticed_3 = true
						
						if finished_image_metadata():
							print("done!")
							#TODO: FINISH

			elif current_rows[0].contains("GPSDate") && current_rows[1].contains("DateTime") || current_rows[0].contains("DateTime") && current_rows[1].contains("GPSDate"):
				if selected_img == Global.img4:
					if !date_time_noticed_4:
						Global.img4_count += 1
						get_parent().get_node("Label").text = str(Global.img3_count)
						date_time_noticed_4 = true
						
						if finished_image_metadata():
							print("done!")
							#TODO: FINISH

	elif current_rows[0].contains("Make") || current_rows[1].contains("Make") || current_rows[0].contains("Model") || current_rows[1].contains("Model"):
		print("make and model")

		if current_rows[0].contains("Make") && current_rows[1].contains("Model") || current_rows[1].contains("Make") && current_rows[0].contains("Model"):
			if a.contains("Apple") && b.contains("iP") || b.contains("Apple") && a.contains("iP"):
					match_msg = "makes sense"
					
					if selected_img == Global.img2:
						if !model_noticed_2:
							Global.img2_count += 1
							get_parent().get_node("Label").text = str(Global.img2_count)
							model_noticed_2 = true
							
							if finished_image_metadata():
								print("done!")
								#TODO: FINISH
							
					elif selected_img == Global.img3:
						if !model_noticed_3:
							Global.img3_count += 1
							get_parent().get_node("Label").text = str(Global.img3_count)
							model_noticed_3 = true
							
							if finished_image_metadata():
								print("done!")
								#TODO: FINISH
								
		elif  current_rows[0].contains("Make") && current_rows[1].contains("Make"):
			if a.contains(b) || b.contains(a):
				match_msg = "the makes match"
			else:
				if selected_img == Global.img2:
					if !make_noticed_1:
						Global.img1_count += 1
						get_parent().get_node("Label").text = str(Global.img2_count)
						make_noticed_1 = true
						
						if finished_image_metadata():
							print("done!")
							#TODO: FINISH
							
		elif  current_rows[0].contains("Model") && current_rows[1].contains("Model"):
			if a.contains(b) || b.contains(a):
				match_msg = "the models match"
			else:
				if selected_img == Global.img1:
					if !model_noticed_1:
						Global.img1_count += 1
						get_parent().get_node("Label").text = str(Global.img1_count)
						model_noticed_1 = true
						
						if finished_image_metadata():
							print("done!")
							#TODO: FINISH

		else:
			if current_rows[0].contains("Software") || current_rows[1].contains("Software"):
				if a.contains("Photoshop") || b.contains("Photoshop"):
					match_msg = "Photoshop?"

					if selected_img == Global.img3:
						if !software_noticed_1:
							_dialogue("m3.0")
							
							Global.img3_count += 1
							get_parent().get_node("Label").text = str(Global.img3_count)
							software_noticed_1 = true
							
							if finished_image_metadata():
								print("done!")
								#TODO: FINISH

			elif current_rows[0].contains("Description") || current_rows[1].contains("Description"):
				if selected_img == Global.img3:
					if !model_noticed_4:
						Global.img3_count += 1
						get_parent().get_node("Label").text = str(Global.img3_count)
						model_noticed_4 = true
						
						if finished_image_metadata():
							print("done!")
							#TODO: FINISH
			else:
				match_msg = "correlates"

	elif current_rows[0].contains("GPS") || current_rows[1].contains("GPS"): #will be true either way - only gps matches with gps
		if current_rows[0].contains("Ref"):
			match_msg = a + " " + b
		elif current_rows[1].contains("Ref"):
			match_msg = b + " " + a
		
		if current_rows[0].contains("Longitude") && current_rows[1].contains("Latitude") || current_rows[0].contains("Latitude") && current_rows[1].contains("Longitude"):
			match_msg = "long vs lat"

			if selected_img == Global.img1:
				if !GPS_noticed_1:
					_dialogue("m4.0")
					
					Global.img1_count += 1
					get_parent().get_node("Label").text = str(Global.img1_count)
					GPS_noticed_1 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH

			elif selected_img == Global.img2:
				if !GPS_noticed_2:
					Global.img2_count += 1
					get_parent().get_node("Label").text = str(Global.img2_count)
					GPS_noticed_2 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH

			elif selected_img == Global.img4:
				if !GPS_noticed_3:
					Global.img4_count += 1
					get_parent().get_node("Label").text = str(Global.img4_count)
					GPS_noticed_3 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
							
		elif current_rows[0].contains("Altitude") && current_rows[1].contains("AltitudeRef") || current_rows[0].contains("AltitudeRef") && current_rows[1].contains("Altitude"):
			if selected_img == Global.img4:
				if !GPS_noticed_4:
					Global.img4_count += 1
					get_parent().get_node("Label").text = str(Global.img4_count)
					GPS_noticed_4 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
						
	elif current_rows[0].contains("Artist") || current_rows[1].contains("Artist"):
		if current_rows[0].contains("Copyright") || current_rows[1].contains("Copyright"):
			if selected_img == Global.img3:
				if !artist_noticed_1:
					Global.img3_count += 1
					get_parent().get_node("Label").text = str(Global.img3_count)
					artist_noticed_1 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
						
		elif current_rows[0].contains("Description") || current_rows[1].contains("Description"):
			if selected_img == Global.img4:
				if !artist_noticed_2:
					Global.img4_count += 1
					get_parent().get_node("Label").text = str(Global.img4_count)
					artist_noticed_2 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
						
	elif current_rows[0].contains("LensSpecification") && current_rows[1].contains("FocalLength") || current_rows[0].contains("FocalLength") && current_rows[1].contains("LensSpecification"):
			if selected_img == Global.img4:
				if !lens_noticed_1:
					Global.img4_count += 1
					get_parent().get_node("Label").text = str(Global.img4_count)
					lens_noticed_1 = true
					
					if finished_image_metadata():
						print("done!")
						#TODO: FINISH
						
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
	var LINE_COLOUR = Color(0.932, 0.863, 0.767)
	if draw_allowed:
		var accum = 0.0
		var current_length = progress * total_length
		for i in range(coords1.size()-1):
			var p1 = coords1[i]
			var p2 = coords1[i+1]
			var seg_len = segment_lengths[i]
			if accum + seg_len <= current_length:
				draw_dashed_line(p1,p2,LINE_COLOUR, 3.0)
			elif accum < current_length:
				var t = (current_length - accum) / seg_len
				var partial_point = p1.lerp(p2,t)
				draw_dashed_line(p1,partial_point,LINE_COLOUR,3.0)
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
				draw_dashed_line(p1,p2,LINE_COLOUR, 3.0)
			elif accum2 < current_length2:
				var t = (current_length2 - accum2) / seg_len
				var partial_point = p1.lerp(p2,t)
				draw_dashed_line(p1,partial_point,LINE_COLOUR,3.0)
				break
			else:
				break
			accum2 += seg_len
			
	if correlates:
		if progress == 1.0:
			#draw_string(font,Vector2(coords1[-1][0] + FONT_SIZE, coords1[-1][1] + FONT_SIZE/2),match_msg,0,-1,FONT_SIZE,FONT_COLOUR)
			var comment = preload("res://metadata/comment.tscn").instantiate()
			add_child(comment)
			comment.get_node("dialogue_label").start(match_msg)
			comment.position = Vector2(coords1[-1][0] + FONT_SIZE, coords1[-1][1] - comment.size.y / 2)
		
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
	correlates = false

func _dialogue(topic:String):
	if pc.has_node("dialogue_display"):
		pc.remove_child(pc.get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	pc.add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", topic)


func finished_all_metadata():
	return GPS_noticed_1 && date_time_noticed_1 && model_noticed_1 \
		&& model_noticed_2 && date_time_noticed_2 && make_noticed_1 && GPS_noticed_2 \
		&& artist_noticed_1 && model_noticed_4 && date_time_noticed_3 && software_noticed_1 && model_noticed_3 \
		&& GPS_noticed_3 && GPS_noticed_4  && lens_noticed_1 && date_time_noticed_4 && artist_noticed_2
	
func finished_image_metadata():
	if selected_img == Global.img1:
		return GPS_noticed_1 && date_time_noticed_1 && model_noticed_1
	elif selected_img == Global.img2:
		return model_noticed_2 && date_time_noticed_2 && make_noticed_1 && GPS_noticed_2
	elif selected_img == Global.img3:
		return artist_noticed_1 && model_noticed_4 && date_time_noticed_3 && software_noticed_1 && model_noticed_3
	elif selected_img == Global.img4:
		return GPS_noticed_3 && GPS_noticed_4  && lens_noticed_1 && date_time_noticed_4 && artist_noticed_2
