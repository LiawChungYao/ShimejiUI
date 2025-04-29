extends Node2D

@onready var shimeji = $Shimeji
@onready var scrollbox = $ScrollBox
@onready var fileloader = $FileLoader
@onready var button = $Button

var image_path: Array[String] = []
var action_data: Array = []

func _ready():
	print("Hello")
	shimeji.fileloader = fileloader
	
	



func _on_button_pressed() -> void:
	shimeji.play_from_actions("Walk")
	pass # Replace with function body.
