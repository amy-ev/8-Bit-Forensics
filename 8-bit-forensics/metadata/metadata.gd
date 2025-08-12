extends NinePatchRect

@onready var _load_files = preload("res://file_dialog/load_file.tscn")
@onready var pc = get_parent().get_parent()

@export var current_image: String

var load_file_open:bool

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

var finished_count:int

var new_file_open: bool

var noticed = {
	"image1": [false,false,false],
	"image2": [false,false,false,false],
	"image3": [false,false,false,false,false],
	"image4": [false,false,false,false,false]
}

var selected_img:PackedByteArray

func _ready() -> void:
	font = preload("res://8-bit-forensics.ttf")
	Global.connect("metadata_selected", _on_label_selected)
	Global.emit_signal("next_step",self)
	
func _on_select_pressed() -> void:
	if !load_file_open:
		var load_files = _load_files.instantiate()
		add_child(load_files)
		load_file_open = true
		
		await load_files.tree_exited
		
		load_file_open = false
		
	if has_node("comment"):
		remove_child(get_node("comment"))
		
	clear_values()
	current_select.clear()
	current_rows.clear()
	new_file_open = true
	
	queue_redraw()
	

	
	for hbox in $scroll/data_container.get_children():
		keys_and_values.append(hbox)
	if !Global.selected_file.is_empty():
		selected_img = Global.get_image(Global.user_path + "evidence_files/" + Global.selected_file)
		$thumbnail_column/thumbnail.set_visible(true)

func _on_exit_pressed() -> void:
	load_file_open = false
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
	if new_file_open:
		current_select.clear()
		current_rows.clear()
		new_file_open = false
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
		
		if (current_rows[0] == "DateTime" && (current_rows[1].contains("DateTimeOriginal")) || current_rows[1].contains("DateTimeDigitized")) || (current_rows[1] == "DateTime" && (current_rows[0].contains("DateTimeOriginal") || current_rows[0].contains("DateTimeDigitized"))):
			if a == b:
				match_msg = a
			else: 
				match_msg = "these do not match"
				
			if selected_img == Global.img1:
				if !noticed["image1"][0]:
					Global.img1_count += 1
					$counter.text = str(Global.img1_count) + " / 3"
					noticed["image1"][0] = true

					if finished_image_metadata():
						update_progress("image 1")
						if finished_count < 4:
							_dialogue("m3.0")

		if (current_rows[0] == "DateTimeOriginal" && current_rows[1] == "DateTimeDigitized") || (current_rows[1] == "DateTimeOriginal" && current_rows[0] == "DateTimeDigitized"):
			if a == b:
				match_msg = a
			
			if selected_img == Global.img2:
				if !noticed["image2"][1]:
					Global.img2_count += 1
					$counter.text = str(Global.img2_count) + " / 4"
					noticed["image2"][1] = true
					
					if finished_image_metadata():
						update_progress("image 2")
						if finished_count < 4:
							_dialogue("m3.0")

		if current_rows[0].contains("GPSTime"):
			a = format_gpstime(a)
			
		elif current_rows[1].contains("GPSTime"):
			b = format_gpstime(b)
			
		if current_rows[0].contains("GPSTime") && current_rows[1].contains("GPSDate") || current_rows[1].contains("GPSTime") && current_rows[0].contains("GPSDate"):

			if  current_rows[0].contains("GPSTime"):
				match_msg = b + "  " + a 
			elif current_rows[1].contains("GPSTime"):
				match_msg = a + "  " + b 

		elif current_rows[0].contains("GPSTime") && current_rows[1].contains("DateTime") || current_rows[0].contains("DateTime") && current_rows[1].contains("GPSTime"):
			if current_rows[0].contains("GPSTime"):
				if b.contains(a):
					match_msg = a 
				else:
					match_msg = a + " is not in " + b
			elif current_rows[1].contains("GPSTime"):
				if a.contains(b):
					match_msg = b
				else:
					match_msg =  b + " is not in " + a

			if selected_img == Global.img3:
				if !noticed["image3"][2]:
					_dialogue("m6.0")

					Global.img3_count += 1
					$counter.text = str(Global.img3_count) + " / 5"
					noticed["image3"][2] = true
					
					if finished_image_metadata():
						update_progress("image 3")
						await pc.get_node("dialogue_display").tree_exited
						if finished_count < 4:
							_dialogue("m3.0")

		elif current_rows[0].contains("GPSDate") && current_rows[1].contains("DateTime") || current_rows[0].contains("DateTime") && current_rows[1].contains("GPSDate"):
			if current_rows[0].contains("GPSDate"):
				if b.contains(a):
					match_msg = a
				else:
					match_msg = a + " is not in " + b
			elif current_rows[1].contains("GPSDate"):
				if a.contains(b):
					match_msg = b
				else:
					match_msg =  b + " is not in " + a

			if selected_img == Global.img4:
				if !noticed["image4"][3]:
					Global.img4_count += 1
					$counter.text = str(Global.img4_count) + " / 5"
					noticed["image4"][3] = true
					
					if finished_image_metadata():
						update_progress("image 4")
						if finished_count < 4:
							_dialogue("m3.0")

	elif current_rows[0].contains("Make") || current_rows[1].contains("Make") || current_rows[0].contains("Model") || current_rows[1].contains("Model"):
		match_msg = "Make vs Model OR LensMake vs LensModel OR Make vs LensMake OR Model vs LensModel: " + a + " " + b

		if current_rows[0].contains("Make") && current_rows[1].contains("Model") || current_rows[1].contains("Make") && current_rows[0].contains("Model"):

			if a.contains("Apple") && b.contains("iP") || b.contains("Apple") && a.contains("iP"):
					match_msg = "these correlate"
			elif a.contains("KODAK") && b.contains("KODAK"):
				match_msg = "these correlate"
				
			elif a.contains(b) || b.contains(a):
				match_msg = "these correlate"
			else:
				match_msg = a + " is not from the same device as " + b
				if selected_img == Global.img2:
					if !noticed["image2"][0]:
						Global.img2_count += 1
						$counter.text = str(Global.img2_count) + " / 4"
						noticed["image2"][0] = true
						
						if finished_image_metadata():
							update_progress("image 2")
							if finished_count < 4:
								_dialogue("m3.0")
						
				elif selected_img == Global.img3:
					if !noticed["image3"][4]:
						Global.img3_count += 1
						$counter.text = str(Global.img3_count) + " / 5"
						noticed["image3"][4] = true
						
						if finished_image_metadata():
							update_progress("image 3")
							if finished_count < 4:
								_dialogue("m3.0")
								
		elif  current_rows[0].contains("Make") && current_rows[1].contains("Make"):
			if a.contains("Apple") && b.contains("iP") || b.contains("Apple") && a.contains("iP"):
				match_msg = "these correlate"
			elif a.contains("KODAK") && b.contains("KODAK"):
				match_msg = "these correlate"
			elif a.contains(b) || b.contains(a):
				match_msg = "these are from the same device"
			else:
				match_msg = "these do not match"
				if selected_img == Global.img2:
					if !noticed["image2"][2]:
						Global.img2_count += 1
						$counter.text = str(Global.img2_count) + " / 4"
						noticed["image2"][2] = true
						
						if finished_image_metadata():
							update_progress("image 2")
							if finished_count < 4:
								_dialogue("m3.0")
							
		elif  current_rows[0].contains("Model") && current_rows[1].contains("Model"):
			if a.contains("Apple") && b.contains("iP") || b.contains("Apple") && a.contains("iP"):
				match_msg = "these correlate"
			elif a.contains("KODAK") && b.contains("KODAK"):
				match_msg = "these correlate"
			elif a.contains(b) || b.contains(a):
				match_msg = "these are from the same device"
			else:
				match_msg = "these do not match"
				if selected_img == Global.img1:
					if !noticed["image1"][2]:
						Global.img1_count += 1
						$counter.text = str(Global.img1_count) + " / 3"
						noticed["image1"][2] = true
						
						if finished_image_metadata():
							update_progress("image 1")
							if finished_count < 4:
								_dialogue("m3.0")

		else:
			if current_rows[0].contains("Software") || current_rows[1].contains("Software"):
				if a.contains("Photoshop") || b.contains("Photoshop"):
					match_msg = "Photoshop was used"

					if selected_img == Global.img3:
						if !noticed["image3"][3]:
							_dialogue("m4.0")
							
							Global.img3_count += 1
							$counter.text = str(Global.img3_count) + " / 5"
							noticed["image3"][3] = true
							
							if finished_image_metadata():
								update_progress("image 3")
								await pc.get_node("dialogue_display").tree_exited
								if finished_count < 4:
									_dialogue("m3.0")
				else:
					match_msg = "cannot determine anything from this"

			elif current_rows[0].contains("Description") || current_rows[1].contains("Description"):
				if a.contains("Apple") && b.contains("iP") || b.contains("Apple") && a.contains("iP"):
					match_msg = "these correlate"
				elif a.contains("iP") && b.contains("iP"):
					if current_rows[0].contains("Description"):
						if a.contains(b):
							match_msg = "that tracks"
						else:
							match_msg = "both apple, but not the right phone"
					elif current_rows[1].contains("Description"):
						if b.contains(a):
							match_msg = "that tracks"
						else:
							match_msg = "both apple, but not the right phone"
				elif a.contains("KODAK") && b.contains("KODAK"):
					match_msg = "that tracks"
				else:
					match_msg = "there's nothing to obtain from comparing these"
					
							
				if selected_img == Global.img3:
					if !noticed["image3"][1]:
						Global.img3_count += 1
						$counter.text = str(Global.img3_count) + " / 5"
						noticed["image3"][1] = true
						
						if finished_image_metadata():
							update_progress("image 3")
							if finished_count < 4:
								_dialogue("m3.0")

	elif current_rows[0].contains("GPS") || current_rows[1].contains("GPS"): #will be true either way - only gps matches with gps
		if current_rows[0].contains("Ref"):
			match_msg = a + " " + b
		elif current_rows[1].contains("Ref"):
			match_msg = b + " " + a
		
		if current_rows[0].contains("Longitude") && current_rows[1].contains("Latitude") || current_rows[0].contains("Latitude") && current_rows[1].contains("Longitude"):
			if current_rows[0].contains("Longitude"):
				match_msg = a + " " + b
			elif current_rows[1].contains("Longitude"):
				match_msg = b + " " + a

			if selected_img == Global.img1:
				if !noticed["image1"][1]:
					_dialogue("m5.0")
					
					Global.img1_count += 1
					$counter.text = str(Global.img1_count) + " / 3"
					noticed["image1"][1] = true
					
					if finished_image_metadata():
						update_progress("image 1")
						await pc.get_node("dialogue_display").tree_exited
						
						if finished_count < 4:
							_dialogue("m3.0")


			elif selected_img == Global.img2:
				if !noticed["image2"][3]:
					Global.img2_count += 1
					$counter.text = str(Global.img2_count) + " / 4"
					noticed["image2"][3] = true
					
					if finished_image_metadata():
						update_progress("image 2")
						if finished_count < 4:
							_dialogue("m3.0")

			elif selected_img == Global.img4:
				if !noticed["image4"][0]:
					Global.img4_count += 1
					$counter.text = str(Global.img4_count) + " / 5"
					noticed["image4"][0] = true
					
					if finished_image_metadata():
						update_progress("image 4")
						if finished_count < 4:
							_dialogue("m3.0")
							
		elif current_rows[0].contains("Altitude") && current_rows[1].contains("AltitudeRef") || current_rows[0].contains("AltitudeRef") && current_rows[1].contains("Altitude"):
			if a.contains("b'\\x00'"):
				a = "Above Sea Level"
				match_msg = b + " degrees " + a
			elif b.contains("b'\\x00'"):
				b = "Above Sea Level"
				match_msg = a + " degrees " + b
			if selected_img == Global.img4:
				if !noticed["image4"][1]:
					Global.img4_count += 1
					$counter.text = str(Global.img4_count) + " / 5"
					noticed["image4"][1] = true
					
					if finished_image_metadata():
						update_progress("image 4")
						if finished_count < 4:
							_dialogue("m3.0")
						
	elif current_rows[0].contains("Artist") || current_rows[1].contains("Artist"):
		if current_rows[0].contains("Copyright") || current_rows[1].contains("Copyright"):
			if current_rows[0].contains("Copyright"):
				if a.contains(b):
					match_msg = "looks like the artist has copyrighted this image"
				else:
					match_msg = "looks like it's not the artists' property"
			elif current_rows[1].contains("Copyright"):
				if b.contains(a):
					match_msg = "looks like the artist has copyrighted this image"
				else:
					match_msg = "looks like it's not the artists' property"
					
			if selected_img == Global.img3:
				if !noticed["image3"][0]:
					Global.img3_count += 1
					$counter.text = str(Global.img3_count) + " / 5"
					noticed["image3"][0] = true
					
					if finished_image_metadata():
						update_progress("image 3")
						if finished_count < 4:
							_dialogue("m3.0")
						
		elif current_rows[0].contains("Description") || current_rows[1].contains("Description"):
			if current_rows[0].contains("Description"):
				if a.contains(b):
					match_msg = "looks like the artist added a description"
				else:
					match_msg = "looks like there's a mismatch between who took the photo"
			elif current_rows[1].contains("Description"):
				if b.contains(a):
					match_msg = "looks like the artist added a description"
				else:
					match_msg = "looks like there's a mismatch between who took the photo"
					
			if selected_img == Global.img4:
				if !noticed["image4"][4]:
					Global.img4_count += 1
					$counter.text = str(Global.img4_count) + " / 5"
					noticed["image4"][4] = true
					
					if finished_image_metadata():
						update_progress("image 4")
						if finished_count < 4:
							_dialogue("m3.0")
						
	elif current_rows[0].contains("LensSpecification") && current_rows[1].contains("FocalLength") || current_rows[0].contains("FocalLength") && current_rows[1].contains("LensSpecification"):
			match_msg = "LensSpecification vs FocalLength: " + a + " " + b
			if current_rows[0].contains("LensSpecification"):
				if a.contains(b):
					match_msg = "these correlate"
				else:
					match_msg = "looks like the information has been altered"
			elif current_rows[1].contains("LensSpecification"):
				if b.contains(a):
					match_msg = "these correlate"
				else:
					match_msg = "looks like the information has been altered"
					
			if selected_img == Global.img4:
				if !noticed["image4"][2]:
					Global.img4_count += 1
					$counter.text = str(Global.img4_count) + " / 5"
					noticed["image4"][2] = true
					
					if finished_image_metadata():
						update_progress("image 4")
						if finished_count < 4:
							_dialogue("m3.0")
	else:
		match_msg = "Not Accounted For"  + a + " " + b
		
	if finished_all_metadata():
		if pc.has_node("dialogue_display"):
			await pc.get_node("dialogue_display").tree_exited
		_dialogue("m7.0")
		if pc.has_node("dialogue_display"):
			await pc.get_node("dialogue_display").tree_exited
			set_visible(false)
			Global.emit_signal("all_metadata_found")
			pc.get_node("screen_animation").play("off")
			
			await pc.get_node("screen_animation").animation_finished
			
			get_tree().change_scene_to_file("res://main/desk.tscn")

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
		v_dict[i] = str(int(float(v_dict[i])))
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
			if has_node("comment"):
				remove_child(get_node("comment"))
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
	match_msg = ""

func _dialogue(topic:String):
	if pc.has_node("dialogue_display"):
		pc.remove_child(pc.get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	pc.add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", topic)


func finished_all_metadata():
	return noticed["image1"][0] && noticed["image1"][1] && noticed["image1"][2] \
		&& noticed["image2"][0] && noticed["image2"][1] && noticed["image2"][2] && noticed["image2"][3] \
		&& noticed["image3"][0] && noticed["image3"][1] && noticed["image3"][2] && noticed["image3"][3] \
		&& noticed["image4"][0] && noticed["image4"][1] && noticed["image4"][2] && noticed["image4"][3]

func finished_image_metadata():
	var image1 = noticed["image1"][0] && noticed["image1"][1] && noticed["image1"][2]
	var image2 = noticed["image2"][0] && noticed["image2"][1] && noticed["image2"][2] && noticed["image2"][3]
	var image3 = noticed["image3"][0] && noticed["image3"][1] && noticed["image3"][2] && noticed["image3"][3] && noticed["image3"][4]
	var image4 = noticed["image4"][0] && noticed["image4"][1] && noticed["image4"][2] && noticed["image4"][3] && noticed["image4"][4]
	
	
	finished_count = int(image1) + int(image2) + int(image3) + int(image4)
	print(finished_count)
	if selected_img == Global.img1:
		finished_count 
		return image1
	elif selected_img == Global.img2:
		return image2
	elif selected_img == Global.img3:
		return image3
	elif selected_img == Global.img4:
		return image4

func update_progress(image:String):
	var label = get_node("progress/"+ image)
	label.clear()
	label.push_strikethrough()
	label.append_text(image)
	label.pop()
