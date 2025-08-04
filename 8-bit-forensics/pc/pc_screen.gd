extends Node2D

@onready var screen = $screen
@onready var mini_dialogue = $mini_dialogue

@onready var _dialogue = preload("res://dialogue/dialogue_display.tscn")

func _ready() -> void:

	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	
	await $screen_animation.animation_finished
	
	Global.connect("dialogue_triggered", _on_dialogue_triggered)

	match day:
		1:
			screen.add_child(preload("res://evidence/image_file.tscn").instantiate())
			if !Global.pc_debrief_given:
				_on_dialogue_triggered("e5.0")
		2:
			screen.add_child(preload("res://hex_viewer/hex_viewer.tscn").instantiate())
			if !Global.pc_debrief_given:
				_on_dialogue_triggered("h1.0")
		3:
			screen.add_child(preload("res://metadata/metadata.tscn").instantiate())
			
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
		
	if event is InputEventKey and event.is_action_pressed("escape"):
		
		if Global.hash_verified && Global.file_created:
			if has_node("dialogue_create_file"):
				get_node("dialogue_create_file").queue_free()
				
			if has_node("screen/evidence_file"):
				get_node("screen/evidence_file").queue_free()
				
			if has_node("pc_screen"):
				for i in get_node("pc_screen").get_child_count():
					get_node("pc_screen").get_child(i).queue_free()
			
			$screen_animation.play("off")
			await $screen_animation.animation_finished
			
			get_tree().change_scene_to_file("res://main/desk.tscn")

func _on_screen_child_entered_tree(node: Node) -> void:
	mini_dialogue.set_visible(false)
	
func _on_dialogue_triggered(topic:String):
	if has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = _dialogue.instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", topic)
