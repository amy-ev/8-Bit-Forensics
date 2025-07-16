extends RichTextLabel

@onready var timer = $text_timer
var full_text:String
var is_playing:bool
var char_pos:int

func _ready() -> void:
	pass
	#start("this is a test")

func start(dialogue:String):
	# match called from dialogue manager with json input for dialogue
	full_text = dialogue
	char_pos = 0
	is_playing = true
	timer.start()


func _on_text_timer_timeout() -> void:
	#add a typing sound
	char_pos += 1
	text = full_text.substr(0,char_pos)
	if is_playing and char_pos == full_text.length():
		timer.stop()
		is_playing = false
		
func skip():

	char_pos = full_text.length()
	text = full_text.substr(0,char_pos)
	timer.stop()
	is_playing = false
