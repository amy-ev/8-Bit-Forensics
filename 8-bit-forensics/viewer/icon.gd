extends TextureRect

var _file_name: String 
@onready var _file_icon = texture

func _ready() -> void:
	if Global.first_image_carved:
		set_visible(true)
	
	
func _process(_delta: float) -> void:
	$file_name.text = _file_name
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_double_click():
		var image_viewer = preload("res://viewer/image_viewer.tscn").instantiate()
		
		var image = Image.load_from_file("res://evidence_files/"+_file_icon.get_meta("file_name"))
		var image_texture = ImageTexture.create_from_image(image)
		image_viewer.get_node("image").texture = image_texture
		
		get_parent().add_child(image_viewer)
