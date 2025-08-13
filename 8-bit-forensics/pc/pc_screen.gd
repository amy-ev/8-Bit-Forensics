extends Node2D

@onready var screen = $screen
@onready var mini_dialogue = $mini_dialogue
var hex_finished:bool
#@onready var _dialogue = load("res://dialogue/dialogue_display.tscn")

func _ready() -> void:

	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	
	await $screen_animation.animation_finished
	
	Global.connect("dialogue_triggered", _on_dialogue_triggered)
	Global.connect("all_images_carved",_on_hex_finished)
	Global.connect("all_metadata_found", _on_metadata_finished)
	
	match day:
		1:
			add_child(preload("res://dialogue/dialogue_create_file.tscn").instantiate())
			screen.add_child(preload("res://dialogue/helper.tscn").instantiate())
			screen.add_child(preload("res://evidence/image_file.tscn").instantiate())
			if !Global.pc_debrief_given:
				_on_dialogue_triggered("e5.0")
		2:
			screen.add_child(preload("res://dialogue/helper.tscn").instantiate())
			screen.add_child(preload("res://hex_viewer/hex_viewer.tscn").instantiate())
			if !Global.pc_debrief_given:
				_on_dialogue_triggered("h1.0")
		3:
			screen.add_child(preload("res://dialogue/helper.tscn").instantiate())
			screen.add_child(preload("res://metadata/metadata.tscn").instantiate())
			
			if !Global.pc_debrief_given:
				_on_dialogue_triggered("m1.0")
				
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
		
	if event is InputEventKey and event.is_action_pressed("escape"):
		if !has_node("escape_screen"):
			add_child(preload("res://main/escape_screen.tscn").instantiate())

func _on_screen_child_entered_tree(node: Node) -> void:
	mini_dialogue.set_visible(false)
	
func _on_dialogue_triggered(topic:String):
	if has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = load("res://dialogue/dialogue_display.tscn").instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", topic)

func _on_hex_finished():
	$back_btn.set_visible(true)
	Global.hex_finished = true

func _on_metadata_finished():
	$back_btn.set_visible(true)
	Global.metadata_finished = true

func _on_back_btn_pressed() -> void:
	if Global.hash_verified && Global.file_created:
		
		if Global.unlocked == 1:
			if Global.hex_finished:
				if has_node("screen"):
					get_node("screen").queue_free()
				$screen_animation.play("off")
				await $screen_animation.animation_finished
		
				get_tree().change_scene_to_file("res://main/desk.tscn")

		elif Global.unlocked == 2:
			if Global.metadata_finished:
				if has_node("screen"):
					get_node("screen").queue_free()
				$screen_animation.play("off")
				await $screen_animation.animation_finished
		
				get_tree().change_scene_to_file("res://main/desk.tscn")
		else:

			if has_node("screen"):
				get_node("screen").queue_free()
			
			if has_node("pc_screen"):
				for i in get_node("pc_screen").get_child_count():
					get_node("pc_screen").get_child(i).queue_free()
		
			$screen_animation.play("off")
			await $screen_animation.animation_finished
		
			get_tree().change_scene_to_file("res://main/desk.tscn")
