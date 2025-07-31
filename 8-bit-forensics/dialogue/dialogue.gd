extends RichTextLabel

@onready var timer = $text_timer
var full_text:String
var is_playing:bool
var char_pos:int

func start(dialogue:String):
	# match called from dialogue manager with json input for dialogue
	full_text = dialogue
	char_pos = 0
	is_playing = true
	timer.start()


func _on_text_timer_timeout() -> void:
	#TODO: add a typing sound
	char_pos += 1
	text = full_text.substr(0,char_pos)
	if is_playing and char_pos == full_text.length():
		timer.stop()
		is_playing = false
		Global.emit_signal("text_finished")
		
func skip():
	char_pos = full_text.length()
	text = full_text.substr(0,char_pos)
	timer.stop()
	is_playing = false
	Global.emit_signal("text_finished")
