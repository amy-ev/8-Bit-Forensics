extends Control

@onready var data = [
['14', '4f', 'a6', '4f', '71', '6c', '76', '14', '5f', '95', '14', '8c', 'b3', '80', '7a', '67'],
['b5', '7a', 'c5', 'a6', 'b1', 'a5', 'ea', '16', '76', 'cf', '66', 'b7', '62', 'e2', 'e0', 'ee'],
['28', 'c9', 'f7', '07', 'd6', 'be', '6c', '81', '3c', 'c5', '2f', 'b0', '95', '03', '70', '27'],
['b6', '2b', 'd0', '7c', '34', 'd1', 'c5', '6f', '72', '63', '9b', 'cc', '5b', 'c4', '03', '29'],
['fc', '00', 'f3', '5e', '46', '67', '27', 'cb', '64', '65', '19', 'ab', 'e8', '7f', 'ff', 'd9']
]

func _ready():
	save()
	load_file(4)
	
func save():
	var save_file = FileAccess.open("res://pc/test.JSON", FileAccess.WRITE)
	var results_json = {
		"rows":[]
	}
	
	for row in data:
		var row_dict = {}
		for i in range(row.size()):
			row_dict["column_%d" % i] = row[i]
		results_json["rows"].append(row_dict)
		
	
	var json_string = JSON.stringify(results_json)
	save_file.store_line(json_string)

func load_file(x):

	var save_file = FileAccess.open("res://pc/test.JSON", FileAccess.READ)
	
	var json_string = save_file.get_as_text()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
#	to retrieve all values
	#return json.data
	var rows
	var json_data = json.data
	for i in range(x):
		rows = json_data["rows"][i]
		for j in range(16):
			var values = rows["column_%d" % j]
			$label.text += values
	#return rows
	#var value = rows["column_%d" % y]
	#return value
	
