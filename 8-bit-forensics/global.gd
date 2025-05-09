extends Node

@export var magnification: int = 3
@export var already_on: bool = false

signal selected(selected_node:File, real_file:String)
signal computer(on:bool)
