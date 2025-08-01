extends Node2D

@onready var _debrief = preload("res://dialogue/dialogue_manager.tscn")
@onready var screen = $screen
@onready var dialogue = $mini_dialogue

var hash_verified:bool
var file_created:bool

func _ready() -> void:

	scale = scale * Utility.window_mode()
	var day = Global.unlocked + 1
	
	await $screen_animation.animation_finished
	
	if !Global.pc_debrief_given:
		
		if get_parent().has_node("dialogue_display"):
			get_parent().remove_child(get_node("dialogue_display"))
		var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
		get_parent().add_child(dialogue)
		dialogue.load_dialogue("res://dialogue/dialogue.json", "e5.0")
	
	match day:
		1:
			Global.connect("create_image_file", _on_file_created)
			Global.connect("hash_verified", _on_hash_verified)
			screen.add_child(preload("res://evidence/image_file.tscn").instantiate())
		2:
			screen.add_child(preload("res://hex_viewer/hex_viewer.tscn").instantiate())
		3:
			screen.add_child(preload("res://metadata/metadata.tscn").instantiate())
			
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("fullscreen"):
		scale = scale * Utility.fullscreen_input(event)
		
	if event is InputEventKey and event.is_action_pressed("escape"):
		
		if hash_verified && file_created:
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
	dialogue.set_visible(false)
	
func _on_hash_verified():
	hash_verified = true
	if has_node("dialogue_display"):
		remove_child(get_node("dialogue_display"))
	var dialogue = preload("res://dialogue/dialogue_display.tscn").instantiate()
	add_child(dialogue)
	dialogue.load_dialogue("res://dialogue/dialogue.json", "e7.0")

func _on_file_created():
	file_created = true
