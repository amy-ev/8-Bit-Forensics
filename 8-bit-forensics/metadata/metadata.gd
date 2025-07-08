extends NinePatchRect

@onready var _file_metadata = preload("res://file_dialog/load_file.tscn")
var keys_and_values: Array

var current_select: Array
var current_rows: Array
@export var current_image: String

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
	
	for rect in current_select:
		if rect != selected_rect:
			rect.visible = false
	if selected_rect not in current_select:
		current_select.append(selected_rect)
		current_rows.append(selected.text)
	if current_select.size() > 2:
		for rect in current_select:
			rect.visible = false
		current_select.clear()
		current_rows.clear()
		
	for rect in current_select:
		rect.visible = true
	# if current_select is not null and current_select is not from the label just emitted
	#if current_select and current_select != selected_rect:
		#current_select.visible = false
	#selected_rect.visible = true
	#current_select = selected_rect

#	TODO: MOVE TO ON FLAG PRESSED
	var json_dict = open_json("res://python_files/metadata.json")
	if typeof(json_dict) == TYPE_DICTIONARY:
		if json_dict.has("file_%s" %current_image):
			print(json_dict["file_" + current_image][selected.text])

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
						break
	else:
		if current_rows.size() == 0:
			return
		else:
			for i in interesting.size():
				if current_rows[0] == interesting[i]:
					print("interesting")
					break
			# continue to check the values
